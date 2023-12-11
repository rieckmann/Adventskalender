clc
clear all

file = fopen('A11.txt');
data = fread(file,[142, 140])';
data = data(:,1:140)-46;
fclose(file);

universe = data;
% count galaxies
[galaxiesR, galaxiesC] = ind2sub(size(universe),find(universe == -11));
emptyrows = sum(universe,2) == 0;
emptycols = sum(universe,1) == 0;

dist = sum(arrayfun(@(id) distance(id, id+1, galaxiesR, galaxiesC, ~emptyrows + 2 * emptyrows, ~emptycols + 2 * emptycols), 1:numel(galaxiesR)));
disp(['Part 1 solution: ', num2str(dist)])

dist2 = sum(arrayfun(@(id) distance(id, id+1, galaxiesR, galaxiesC, ~emptyrows + 10^6 * emptyrows, ~emptycols + 10^6 * emptycols), 1:numel(galaxiesR)));
disp(['Part 2 solution: ', num2str(dist2)])

function dist = distance(id0, id1, galaxiesRows, galaxiesCols, universeRows, universeCols)
    dist = 0;
    if id1 <= numel(galaxiesRows)
        idx = [galaxiesRows(id0), galaxiesCols(id0);galaxiesRows(id1), galaxiesCols(id1)];
        rowDist = sum(universeRows(min(idx(:,1)):max(idx(:,1))))-1;
        colDist = sum(universeCols(min(idx(:,2)):max(idx(:,2))))-1;
%         disp(['Distance between ',num2str(id0), ' and ', num2str(id1), ' : ', num2str(rowDist+colDist)]);
        dist = distance(id0, id1+1, galaxiesRows, galaxiesCols, universeRows, universeCols) + rowDist + colDist;
    end
end