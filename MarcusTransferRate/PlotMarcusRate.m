% Assuming your 101x11 double array is named 'data'
% and the first column is the x-axis values.
field_name = 'kLECT0650';
deltaG_values = 0.05:0.10:0.45;

data = kLECT_Angle_vars.(field_name);
% data = kLECT_vars.(field_name);
% Extract x-axis data
x = data(:, 1);

% Extract the remaining 10 columns for plotting
y_matrix = data(:, 2:end);

% Method 1: Plotting each column individually

% figure; % Create a new figure window
% hold on; % Keep all plots on the same axes
% 
% for i = 1:size(y_matrix, 2)  % Loop through each column
%     plot(x, y_matrix(:, i));
% end
% 
hold off; % Release the axes
% 
% xlabel('X-axis values');
% ylabel('Y-axis values');
% title('Plot of 10 Data Series');
% %legend('Series 1', 'Series 2', 'Series 3', ..., 'Series 10'); % Add a legend (optional)

% Extract lambda and d_CT values from the field name (or directly from your lambda_values and ct_distance_values)
lambda_str = field_name(6:7); % Extract lambda (e.g., '06')
d_ct_str = field_name(8:end); % Extract d_CT (e.g., '15')

lambda = str2double(lambda_str)/10;    % Convert to number (e.g., 0.06)
d_ct = str2double(d_ct_str)/10;        % Convert to number (e.g., 15)

% Create the plot title dynamically
plot_title = sprintf('\\lambda = %.2f eV and d_{CT} = %d nm', lambda, d_ct);


% Method 2: Plotting all columns at once (more efficient)

figure;
% hold on;
h_lines = semilogy(x, y_matrix);  % Directly plot all columns against x
% set(gca, 'YScale', 'log');
set(h_lines, ...
    'LineWidth', 2.5, ...     % Thicker line
    'LineStyle', '-');        % Solid line



% %% --- 2. Highlight the third column ---
% highlight_column_index = 3;
% 
% base_colormap = parula(size(y_matrix, 2)+1); 
% % Factor to desaturate/lighten the colors.
% % A value from 0 (original color) to 1 (completely white).
% % Adjust this value to control how "light" or "subtle" the gradient is.
% desaturation_factor = 0.01; % Example: blends 30% original color with 70% white
% 
% % Apply desaturation: Mix each color with white
% % Resulting_color = Original_color * (1 - factor) + White_color * factor
% subtle_colormap = base_colormap(1:size(y_matrix, 2),:) * (1 - desaturation_factor) + desaturation_factor;
% 
% % --- 2. Customize properties for all non-highlighted lines (optional, for background effect) ---
% for k = 1:length(h_lines) % Loop through all line handles
%     if k ~= highlight_column_index
%         set(h_lines(k), ...
%             'Color', subtle_colormap(k,:), ... % Light grey color
%             'LineWidth', 0.8);          % Thin line
%     end
% end
% 
% % --- 3. Highlight the specific column by modifying its properties in-place ---
% set(h_lines(highlight_column_index), ...
%     'Color', 'r', ...         % Red color
%     'LineWidth', 2.5, ...     % Thicker line
%     'LineStyle', '-');        % Solid line

%% semilogy(x, y_matrix);  % Directly plot all columns against x
ylim([8e8, 2.5e11]);
xlim([0 1e8]);
fontsize(15,"points");

xlabel('F (V/m)');
ylabel('k_{LE-CT} (s^{-1})');
title(plot_title);
% Create legend entries with Delta G symbol
legend_entries = cell(1, length(deltaG_values)); % Cell array to hold strings

for i = 1:length(deltaG_values)
    if i == highlight_column_index
    legend_entries{i} = sprintf('\\DeltaE_{LE-CT} = %.2f -->', deltaG_values(i));
    else
    legend_entries{i} = sprintf('\\DeltaE_{LE-CT} = %.2f', deltaG_values(i));
    end
end

legend(legend_entries);  % Set the legend with formatted strings
% % Method 3:  Plotting with different line styles or colors
% 
% figure;
% plot(x, y_matrix, 'b-', x, y_matrix, 'r--', x, y_matrix, 'g:', ...);  % Example: solid blue, dashed red, dotted green
% 
% % You can customize the line styles and colors for each series.
% % Refer to MATLAB's documentation for 'plot' for more options.
% 
% xlabel('X-axis values');
% ylabel('Y-axis values');
% title('Plot of 10 Data Series');
% legend('Series 1', 'Series 2', 'Series 3', ..., 'Series 10'); % Add a legend (optional)
% 
% 
% % Method 4: Using a loop with customized line styles/colors
% 
% figure;
% hold on;
% 
% lineStyles = {'-', '--', ':', '-.'}; % Define line styles
% colors = {'b', 'r', 'g', 'k', 'm', 'c', 'y'}; % Define colors
% 
% for i = 1:size(y_matrix, 2)
%     styleIndex = mod(i-1, length(lineStyles)) + 1;  % Cycle through line styles
%     colorIndex = mod(i-1, length(colors)) + 1; % Cycle through colors
%     plot(x, y_matrix(:, i), [colors{colorIndex} lineStyles{styleIndex}]);
% end
% 
% hold off;
% 
% xlabel('X-axis values');
% ylabel('Y-axis values');
% title('Plot of 10 Data Series');
% legend('Series 1', 'Series 2', 'Series 3', ..., 'Series 10'); % Add a legend (optional)
% 
% 
% % Choose the method that best suits your needs in terms of efficiency
% % and customization.  Method 2 is generally the most efficient for
% % plotting all series at once. Method 4 provides the most flexibility
% % in terms of customizing the appearance of individual lines.