clc
clear all

file = fopen('A11.txt');
data = fread(file,[142, 140])';
data = data(:,1:140)-45;
fclose(file);

universe = data;
% count galaxies
galaxies = find(universe == -10);

%expand
universeRows = expanduniverse(universe, 1, 1, 2);
universeCols = expanduniverse(universe, 2, 1, 2);
universeRows(galaxies) = 1;
universeCols(galaxies) = 1;

% count distances
dist = sum(arrayfun(@(id) distance(id, id+1, galaxies, universeRows, universeCols), 1:numel(galaxies)));
disp(['Part 1 solution: ', num2str(dist)])

% part 2
universeRows = expanduniverse(universe, 1, 1, 10^6);
universeCols = expanduniverse(universe, 2, 1, 10^6);
universeRows(galaxies) = 1;
universeCols(galaxies) = 1;

% count distances
dist2 = sum(arrayfun(@(id) distance(id, id+1, galaxies, universeRows, universeCols), 1:numel(galaxies)));
disp(['Part 2 solution: ', num2str(dist2)])

function X = expanduniverse(X, dir, idx, factor)
    if dir == 1
        if sum(X(idx,:))==numel(X(idx,:))
            X(idx,:) = factor;
        end        
    elseif dir == 2
        if sum(X(:,idx))==numel(X(:,idx))
            X(:,idx) = factor;
        end
    end
    idx = idx + 1;
    if idx <= size(X,dir)
    	X = expanduniverse(X, dir, idx, factor);
    end
end

function dist = distance(id0, id1, galaxies, universeRows, universeCols)
    dist = 0;
    if id1 <= numel(galaxies)
        [i0, j0] = ind2sub(size(universeRows),galaxies(id0));
        [i1, j1] = ind2sub(size(universeRows),galaxies(id1));
        rowDist = sum(universeRows(min(i0,i1):min(i0,i1)+abs(i1-i0),min(j0,j1)))-1;
        colDist = sum(universeCols(max(i0,i1),min(j0,j1):min(j0,j1)+abs(j1-j0)))-1;
%         disp(['Distance between ',num2str(id0), ' and ', num2str(id1), ' : ', num2str(rowDist+colDist)]);
        dist = distance(id0, id1+1, galaxies, universeRows, universeCols) + rowDist + colDist;
    end
end