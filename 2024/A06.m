clc
clear all
close all

file = fileread('A06.txt');

%% preprocessing
data = char(splitlines(file));

%% actual code
adventdriver(@part1, data);

adventdriver(@part2, data);

function r = part1(data)
    r = 1;
    [row, column] = find(data == '^' | data == '>' | data == 'v' | data == '<' );
    direction = data(row, column);
    
    walking = true;
    while walking
        n = 0;
        
        if direction == '^'
            direction = '>';
            path = data(1:row-1, column);
            path = flip(path');              
            path = split(path,'#');
            walking = numel(path) > 1;
            path = char(path(1));
            n = numel(path);
            r = r + sum(path == '.');
            data(row-n:row, column) = '|';
            data(row, column) = '+';
            row = row - n;
            data(row, column) = '+';
        elseif direction == '>'
            direction = 'v';
            path = data(row, column+1:end);
            path = split(path,'#');
            walking = numel(path) > 1;
            path = char(path(1));
            n = numel(path);
            r = r + sum(path == '.');
            data(row, column:column+n) = '-';
            data(row, column) = '+';
            column = column + n;
            data(row, column) = '+';
        elseif direction == 'v'
            direction = '<';
            path = data(row+1:end, column);    
            path = path';              
            path = split(path,'#');   
            walking = numel(path) > 1;
            path = char(path(1));
            n = numel(path);
            r = r + sum(path == '.');
            data(row:row+n, column) = '|';
            data(row, column) = '+';
            row = row + n;
            data(row, column) = '+';
        elseif direction == '<'
            direction = '^';
            path = data(row, 1:column-1);   
            path = flip(path);              
            path = split(path,'#');   
            walking = numel(path) > 1;
            path = char(path(1));
            n = numel(path);
            r = r + sum(path == '.');
            data(row, column - n:column) = '-';
            data(row, column) = '+';
            column = column - n;
            data(row, column) = '+';
        end        
    end
    
end


function r = part2(data)
    r = 0;
    [row, column] = find(data == '^' );
    direction = 1;
    data_bkup = data;
    row_bkup = row;
    column_bkup = column;
    direction_bkup = direction;
    

    %simulate once part1, where the guard does not go, no obstacle makes
    %sense
    walking = true;
    while walking
        n = 0;
        if direction == 1
            direction = 2;
            path = data(1:row-1, column);
            path = flip(path');              
            path = split(path,'#');
            walking = numel(path) > 1;
            path = char(path(1));
            n = numel(path);

            data(row-n:row, column) = 'X';
            row = row - n;
        elseif direction == 2
            direction = 3;
            path = data(row, column+1:end);
            path = split(path,'#');
            walking = numel(path) > 1;
            path = char(path(1));
            n = numel(path);

            data(row, column:column+n) = 'X';
            column = column + n;
        elseif direction == 3
            direction = 4;
            path = data(row+1:end, column);    
            path = path';              
            path = split(path,'#');   
            walking = numel(path) > 1;
            path = char(path(1));
            n = numel(path);

            data(row:row+n, column) = 'X';
            row = row + n;
        elseif direction == 4
            direction = 1;
            path = data(row, 1:column-1);   
            path = flip(path);              
            path = split(path,'#');   
            walking = numel(path) > 1;
            path = char(path(1));
            n = numel(path);

            data(row, column - n:column) = 'X';
            column = column - n;
        end  
    end
    data_orig = data;
        
    for i = 1:numel(data_bkup)
        data = data_bkup;
        row = row_bkup;
        column = column_bkup;
        direction = direction_bkup;
        if data_orig(i) ~= 'X'
            continue;
        else
            data(i) = '#';
        end
        
        track = cell(4,1);
        walking = true;
        while walking
            n = 0;
            ind = sub2ind(size(data), row, column);
            if any(track{direction} == ind)
                r = r+1;
                walking = false;
                continue;
            end
            
            track{direction} = [track{direction}, sub2ind(size(data), row, column)];
                
            if direction == 1                
                direction = 2;
                path = data(1:row-1, column);
                path = flip(path');              
                path = split(path,'#');
                walking = numel(path) > 1;
                path = char(path(1));
                n = numel(path);                
                data(row-n:row, column) = 'X';
                row = row - n;
            elseif direction == 2
                direction = 3;
                path = data(row, column+1:end);
                path = split(path,'#');
                walking = numel(path) > 1;
                path = char(path(1));
                n = numel(path);
                data(row, column:column+n) = 'X';
                column = column + n;
            elseif direction == 3
                direction = 4;
                path = data(row+1:end, column);    
                path = path';              
                path = split(path,'#');   
                walking = numel(path) > 1;
                path = char(path(1)); 
                n = numel(path);
                data(row:row+n, column) = 'X';
                row = row + n;
            elseif direction == 4
                direction = 1;
                path = data(row, 1:column-1);   
                path = flip(path);              
                path = split(path,'#');   
                walking = numel(path) > 1;
                path = char(path(1));
                n = numel(path);
                data(row, column - n:column) = 'X';
                column = column - n;
            end 
        end
    end    
end