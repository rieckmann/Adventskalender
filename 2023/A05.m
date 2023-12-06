clc
clear all

txt = readlines("A05.txt");
seeds = cellfun(@str2num ,regexp(txt(1), '(\d+)', 'tokens'));

Columns = {'Source','Destination', 'DestinationId', 'SourceId', 'Length'};
DataTypes = {'string', 'double', 'double', 'double'};
T = array2table(zeros(0,5),'VariableNames', Columns);

emptyrows = find(cellfun(@isempty ,txt));
for i=1:size(emptyrows,1)-1
    Categories = regexp(txt{emptyrows(i)+1}, '(\w+)-\w+-(\w+)', 'tokens');
    Data = arrayfun(@str2num ,split(txt(emptyrows(i)+2:emptyrows(i+1)-1),' '));
    C = strings(size(Data,1),2);
    C(:,1) = Categories{1}{1};
    C(:,2) = Categories{1}{2};
    T = [T;[array2table(C,'VariableNames', Columns(1:2)),array2table(Data,'VariableNames', Columns(3:end))]];
end

locations = zeros(size(seeds));
for i=1:size(seeds,2)
    locations(i) = convertsingle(seeds(i),"seed",T);
end

disp(['Part 1 solution: ', num2str(min(locations))])

seeds2 = seeds(1, 1:2:end-1);
ranges2 = seeds(1, 2:2:end);
locations2 = zeros(size(seeds2));
for i=1:size(seeds2,2)
    locations2(i) = convertrange(seeds2(i),ranges2(i),"seed",T);
end
disp(['Part 2 solution: ', num2str(min(locations2))])

function location = convertsingle(seed, key, T)
    location = seed;
    if key ~= "location"
        Tab = T(T.Source == key,:);        
        mapped = false;        
        for j=1:height(Tab)
            if seed >= Tab.SourceId(j) && seed < Tab.SourceId(j)+Tab.Length(j)
                mapped = true;
                location = convertsingle(Tab.DestinationId(j) + (seed - Tab.SourceId(j)), Tab.Destination(1), T);
                break;
            end
        end
        
        if ~mapped
            location = convertsingle(seed, Tab.Destination(1), T);
        end
    end
end

function location = convertrange(seed, range, key, T)
    location = seed;
    if key ~= "location"
        Tab = T(T.Source == key,:);
        mapped = false;
        for j=1:height(Tab)
            if location >= Tab.SourceId(j) && location < Tab.SourceId(j)+Tab.Length(j)
                mapped = true;
                if location+range <= Tab.SourceId(j)+Tab.Length(j) 
                    location = convertrange(Tab.DestinationId(j) + (seed - Tab.SourceId(j)), range, Tab.Destination(1), T);                  
                else
                    seed2 = Tab.SourceId(j)+Tab.Length(j);
                    range2 = (location+range)-(Tab.SourceId(j)+Tab.Length(j));
                    location = min(convertrange(location, range-range2, key, T), convertrange(seed2, range2, key, T));
                end
                break;
            end
        end
        
        if ~mapped
            location = convertrange(location, range, Tab.Destination(1), T);
        end
    end
end

