clc
clear all

file = fopen('A11.txt');
data = fread(file,[142, 140])';
data = data(:,1:140)-46;
fclose(file);

% file = fopen('A11test.txt');
% data = fread(file,[12, 10])';
% data = data(:,1:10)-46;
% fclose(file);

% expand
universe = data;
universe = expanduniverse(universe, 1, 1);
universe = expanduniverse(universe, 2, 1);

% count galaxies
galaxies = find(universe == -11);
universe(galaxies) = 1:numel(galaxies);

% count distances
dist = sum(arrayfun(@(id) distance(id, id+1, galaxies, universe), 1:numel(galaxies)));
disp(['Part 1 solution: ', num2str(dist)])

% part 2
universe2 = data;
universeRows = expanduniverse2(universe2+1, 1, 1);
universeColumns = expanduniverse2(universe2+1, 2, 1);

% count galaxies
galaxies2 = find(universe2 == -11);
universe2(galaxies2) = 1:numel(galaxies2);
universeRows(galaxies2) = 1;
universeColumns(galaxies2) = 1;

% count distances
dist2 = sum(arrayfun(@(id) distance2(id, id+1, galaxies2, universeRows, universeColumns), 1:numel(galaxies2)));
disp(['Part 2 solution: ', num2str(dist2)])

function X = expanduniverse(X, dir, idx);
    if dir == 1
        if sum(X(idx,:))==0
            X = [X(1:idx,:);X(idx,:);X(idx+1:end,:)];
            idx = idx + 1;            
        end        
    elseif dir == 2
        if sum(X(:,idx))==0
            X = [X(:,1:idx),X(:,idx),X(:,idx+1:end)];
            idx = idx + 1;
        end
    end
    idx = idx + 1;
    if idx <= size(X,dir)
    	X = expanduniverse(X, dir, idx);
    end
end

function X = expanduniverse2(X, dir, idx)
    if dir == 1
        if sum(X(idx,:))==numel(X(idx,:))
            X(idx,:) = 10^6;
        end        
    elseif dir == 2
        if sum(X(:,idx))==numel(X(:,idx))
            X(:,idx) = 10^6;
        end
    end
    idx = idx + 1;
    if idx <= size(X,dir)
    	X = expanduniverse2(X, dir, idx);
    end
end

function dist = distance(id0, id1, galaxies, universe)
    dist = 0;
    if id1 <= numel(galaxies)
        [i0, j0] = ind2sub(size(universe),galaxies(id0));
        [i1, j1] = ind2sub(size(universe),galaxies(id1));
        rowDist = abs(i1-i0);
        colDist = abs(j1-j0);
%         disp(['Distance between ',num2str(id0), ' and ', num2str(id1), ' : ', num2str(rowDist+colDist)]);
        dist = distance(id0, id1+1,galaxies,universe) + rowDist + colDist;
    end
end

function dist = distance2(id0, id1, galaxies, universeRows, universeCols)
    dist = 0;
    if id1 <= numel(galaxies)
        [i0, j0] = ind2sub(size(universeRows),galaxies(id0));
        [i1, j1] = ind2sub(size(universeRows),galaxies(id1));
        rowDist = sum(universeRows(min(i0,i1):min(i0,i1)+abs(i1-i0),min(j0,j1)))-1;
        colDist = sum(universeCols(max(i0,i1),min(j0,j1):min(j0,j1)+abs(j1-j0)))-1;
%         disp(['Distance between ',num2str(id0), ' and ', num2str(id1), ' : ', num2str(rowDist+colDist)]);
        dist = distance2(id0, id1+1, galaxies, universeRows, universeCols) + rowDist + colDist;
    end
end