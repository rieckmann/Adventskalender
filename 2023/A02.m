clc
clear all

txt = num2cell(readlines("A02.txt"));
games = cellfun(@order, txt, 'Uniform', false);
pgames = cellfun(@valid, games);
disp(['Part 1 solution: ', num2str(sum(find(pgames)))])
ngames = cellfun(@mini, games);
disp(['Part 2 solution: ', num2str(sum((ngames)))])
function Y = order(Y)
    Y = regexprep(Y,"Game \d+:", "");
    Y = num2cell(split(Y, ';', 1));
    Y = cellfun(@sort, Y, 'Uniform', false);
end
function rgb = sort(Y)
    Y = split(Y, ',', 1);
    Y = split(strtrim(Y), ' ', 2);    
    rgb = zeros(1,3);
    for i=1:size(Y,1)
        color = Y(i,2);
        if color == "red"
            rgb(1) = Y(i,1);
        elseif color == "green"
            rgb(2) = Y(i,1);
        elseif color == "blue"
            rgb(3) = Y(i,1);
        end
    end
end
function x = valid(Y)
    limit = [12, 13, 14];    
    x = all(all(cell2mat(Y) <= limit));
end
function x = mini(Y)   
    x = prod(max(cell2mat(Y)));
end