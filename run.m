% Model name
modelName = 'BLDCDriveModelWithController';

% Parameter sets (you can add more rows)
params = [
 
    0.30, 0.0010, 0.05, 120, 24, 5, 0.001, 0.005, 4;
   0.20, 0.0008, 0.08, 120, 48, 15, 0.002, 0.01, 4;
   0.30, 0.0010, 0.05, 120, 48, 5, 0.005, 0.05, 4;
   0.05, 0.0003, 0.15, 90, 160, 160, 0.1, 0.05, 4;
   0.03, 0.0002, 0.20, 120, 250, 200, 0.15, 0.1, 4;
   0.03, 0.00048, 0.20, 120, 400, 200, 0.75, 0.08, 4;
   0.015, 0.00015, 0.30, 120, 575, 400, 1.00, 0.02, 4;
   0.008, 0.00005, 0.40, 120, 800, 600, 0.50, 0.1, 4;

];

% Parameter names
paramNames = {'Rs', 'Ls', 'flux', 'BEMF', 'Vdc', 'Tm', 'J', 'B', 'PolePairs'};

% Output variable names
outputNames = {
    'Vca', 'Vbc', 'Vab', 'Vc', 'Vb', 'Va', ...
    'Ha', 'Hb', 'Hc', ...
    'Is_a', 'Is_b', 'Is_c', ...
    'backemf_a', 'backemf_b', 'backemf_c', ...
    'Rotor_Speed', 'Electromagnetic_Torque'
};

% Excel file
excelFile = 'SimulationResults.xlsx';

% Load Simulink model
load_system(modelName);

% Solver and simulation settings
set_param(modelName, ...
    'StopTime', '15', ...
    'Solver', 'ode23tb', ...
    'RelTol', '1e-4', ...
    'SolverResetMethod', 'Robust', ...
    'MaxStep', '1e-3', ...
    'MinStep', 'auto');

% Decimation setting
simoutBlock = find_system(modelName, 'BlockType', 'ToWorkspace', 'VariableName', 'simout');
if ~isempty(simoutBlock)
    set_param(simoutBlock{1}, 'Decimation', '50');
end

% Run simulations
for i = 1:size(params, 1)
    fprintf('▶️ Running simulation %d/%d...\n', i, size(params, 1));

    % Assign parameters
    for j = 1:length(paramNames)
        assignin('base', paramNames{j}, params(i, j));
    end

    % Simulate
    simOut = sim(modelName);

    % Get simout data
    sim_data = evalin('base', 'simout');
    if isnumeric(sim_data)
        sim_matrix = sim_data;
    elseif isa(sim_data, 'timeseries')
        sim_matrix = sim_data.Data;
    else
        error('Unsupported simout format!');
    end

    % Generate time vector
    nRows = size(sim_matrix, 1);
    Time = linspace(0, 15, nRows)';

    % Extract variables
    Va = sim_matrix(:, strcmp(outputNames, 'Va'));
    Vb = sim_matrix(:, strcmp(outputNames, 'Vb'));
    Vc = sim_matrix(:, strcmp(outputNames, 'Vc'));

    Ia = sim_matrix(:, strcmp(outputNames, 'Is_a'));
    Ib = sim_matrix(:, strcmp(outputNames, 'Is_b'));
    Ic = sim_matrix(:, strcmp(outputNames, 'Is_c'));

    EMFa = sim_matrix(:, strcmp(outputNames, 'backemf_a'));
    EMFb = sim_matrix(:, strcmp(outputNames, 'backemf_b'));
    EMFc = sim_matrix(:, strcmp(outputNames, 'backemf_c'));

    Torque = sim_matrix(:, strcmp(outputNames, 'Electromagnetic_Torque'));
    Speed_RPM = sim_matrix(:, strcmp(outputNames, 'Rotor_Speed'));

    % Convert RPM to rad/s
    Speed = Speed_RPM * 2 * pi / 60;

    % Power calculations
    InputPower = Ia .* Va + Ib .* Vb + Ic .* Vc;
    ElectricalOutputPower = Ia .* EMFa + Ib .* EMFb + Ic .* EMFc;
    MechanicalOutputPower = Torque .* Speed;
    Efficiency = MechanicalOutputPower ./ (InputPower + eps);  % Avoid div by 0

    % Build full matrix
    paramRow = repmat(params(i, :), nRows, 1);
    fullMatrix = [Time, paramRow, sim_matrix, ...
                  InputPower, ElectricalOutputPower, MechanicalOutputPower, Efficiency];

    % Final column names
    allColNames = [{'Time'}, paramNames, outputNames, ...
                   {'Input_Power', 'Electrical_Output_Power', ...
                    'Mechanical_Output_Power', 'Efficiency'}];

    % Save to Excel (new sheet per run)
    resultTable = array2table(fullMatrix, 'VariableNames', allColNames);
    writetable(resultTable, excelFile, 'Sheet', sprintf('Run_%d', i));
end

disp('✅ All simulations completed and saved to Excel!');
