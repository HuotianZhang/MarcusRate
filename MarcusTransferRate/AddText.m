% --- Script to Add Labels to a Semilogy Plot ---

% --- 1. Find the Target Figure and Axes ---
% Find the figure by its name 'Figure 1'.
figHandle = figure(1);

% Check if the figure was found. If not, display an error.
if isempty(figHandle)
    error('Figure with the name "Figure 1" was not found. Please ensure the figure is open.');
end

% Get the axes handle from the figure.
axHandle = gca(figHandle);

% --- 2. Find All Plotted Lines ---
% Find all objects of type 'line' within the axes.
% These are your curves.
allLines = findobj(axHandle, 'Type', 'line');

% Check if we found exactly 6 lines.
if numel(allLines) ~= 6
    error('Expected 6 curves in the figure, but found %d.', numel(allLines));
end

% findobj returns handles in reverse stacking order (last plotted is first).
% We flip the array to get them in the order they were likely plotted (1st, 2nd, ...).
allLines = flipud(allLines);

% --- 3. Loop Through Lines and Add Text Labels ---
fprintf('Adding labels to the plot...\n');

for i = 1:numel(allLines)
    % Get the current line handle
    currentLine = allLines(i);
    
    % --- a. Get Data for Text Positioning ---
    % Extract the X and Y data from the line.
    xData = get(currentLine, 'XData');
    yData = get(currentLine, 'YData');
    
    % We will place the text near the end of the line.
    xPosition = xData(6);
    yPosition = yData(6);
    
    % --- x. Get Line Color ✨ ---
    % Get the RGB color value of the current line.
    lineColor = get(currentLine, 'Color');
    % --- b. Create the Label Text ---
    
    % --- c. Apply Vertical Shift ---
    % For a semilogy plot, multiplying/dividing the Y value creates a
    % consistent vertical shift on the log scale.
    if i <= 3
        % For the first 3 curves (k1, k2, k3), shift the text UP.
        yPosition = yPosition * 1.6; 
        labelText = sprintf('{\\downarrow \\it k}_{Ex-CT} (\\Delta{\\itE}_{Ex-CT} = %.1f eV)', mod(num2str(i)-1,3)*0.2);
    else
        % For the last 3 curves (k4, k5, k6), shift the text DOWN.
        yPosition = yPosition / 1.8;
        labelText = sprintf('{\\uparrow \\it k}_{CT-Ex} (\\Delta{\\itE}_{Ex-CT} = %.1f eV)', mod(num2str(i)-1,3)*0.2);
    end
    
    % --- d. Add the Text to the Plot ---
    % The text() function adds the string to the specified coordinates.
    text(axHandle, xPosition, yPosition, labelText, ...
        'FontSize', 16, ...
        'FontWeight', 'bold', ...
        'HorizontalAlignment', 'left', ...
        'Color', lineColor);
end

fprintf('Done!\n');