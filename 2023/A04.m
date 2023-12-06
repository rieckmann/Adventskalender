clc
clear all

txt = readlines("A04.txt");
txt = regexprep(txt, '[ ]+', ' ');
txt = split(txt, {': ',' | '});
Columns = {'Card', 'WinningNumbers', 'Numbers'};
T = table(arrayfun(@str2double, regexprep(txt(:,1),'Card ','')), arrayfun(@str2double, split(txt(:,2),' ')), arrayfun(@str2double, split(txt(:,3),' ')),'VariableNames',Columns);
T = [T, rowfun(@ismember, T, "InputVariables",["Numbers", "WinningNumbers"], "OutputVariableNames", "Winners")];
T = [T, rowfun(@sum, T, "InputVariables","Winners", "OutputVariableNames", "NumberOfWinners")];
T = [T, rowfun(@(x) 2^(x-1) + 0.5 * min(x-1,0), T, "InputVariables","NumberOfWinners", "OutputVariableNames", "Value")];
disp(['Part 1 solution: ', num2str(sum(T.Value))])

T.NumberOfCopies = ones(size(T.Value));
for row=1:height(T)
    T.NumberOfCopies(row+1:row+T.NumberOfWinners(row)) = T.NumberOfCopies(row+1:row+T.NumberOfWinners(row)) + T.NumberOfCopies(row);
end
disp(['Part 2 solution: ', num2str(sum(T.NumberOfCopies))])



