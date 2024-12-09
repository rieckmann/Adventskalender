clc
clear all
close all

file = fileread('A08.txt');

%% preprocessing
data = string(splitlines(file));

%% actual code
adventdriver(@part1, data);

adventdriver(@part2, data);

function r = part1(data)
    % size
    [n,m] = size(char(data));

    % find all antenna locations
    [antenna, location] = regexp(data, '(\w)', 'tokens');
    antennadict_key = zeros(0,1);
    antennadict_value = cell(0,1);
    for i=1:numel(data)
        for j=1:numel(antenna{i})
            type = double(char(antenna{i}{j}));
            idx = find(antennadict_key == type);
            if ~isempty(idx)
                antennadict_value{idx,1} = [antennadict_value{idx}; i, location{i}(j)];
            else
                antennadict_key = [antennadict_key; type];
                nn = numel(antennadict_key);
                antennadict_value{nn,1} = [i, location{i}(j)];
            end
        end
    end
    
    % collect all antinodes
    antinodes = [];
    for i=1:numel(antennadict_key)
        for j=1:size(antennadict_value{i},1)
            antenna_1 = antennadict_value{i}(j,:);
            for k=(j+1):size(antennadict_value{i},1)
                antenna_2 = antennadict_value{i}(k,:);
                dist = antenna_2 - antenna_1;
                
                node = antenna_1 - dist;
                if node(1) >=1 && node(1) <= n && node(2) >=1 && node(2) <=m
                    idx = sub2ind([n,m], node(1), node(2));
                    if ~any(antinodes == idx)
                        antinodes = [antinodes, idx];
                    end
                end

                node = antenna_2 + dist;
                if node(1) >=1 && node(1) <= n && node(2) >=1 && node(2) <=m
                    idx = sub2ind([n,m], node(1), node(2));
                    if ~any(antinodes == idx)
                        antinodes = [antinodes, idx];
                    end
                end
            end
        end
    end
    r = numel(antinodes);
end

function r = part2(data)
    % size
    [n,m] = size(char(data));

    % find all antenna locations
    [antenna, location] = regexp(data, '(\w)', 'tokens');
    antennadict_key = zeros(0,1);
    antennadict_value = cell(0,1);
    for i=1:numel(data)
        for j=1:numel(antenna{i})
            type = double(char(antenna{i}{j}));
            idx = find(antennadict_key == type);
            if ~isempty(idx)
                antennadict_value{idx,1} = [antennadict_value{idx}; i, location{i}(j)];
            else
                antennadict_key = [antennadict_key; type];
                nn = numel(antennadict_key);
                antennadict_value{nn,1} = [i, location{i}(j)];
            end
        end
    end
    
    % collect all antinodes
    antinodes = [];
    for i=1:numel(antennadict_key)
        for j=1:size(antennadict_value{i},1)
            antenna_1 = antennadict_value{i}(j,:);
            for k=(j+1):size(antennadict_value{i},1)
                antenna_2 = antennadict_value{i}(k,:);
                dist = antenna_2 - antenna_1;
                % factor distance
                factor = gcd(dist(1),dist(2));
                dist = dist/factor;
                
                inside = true;
                node = antenna_1-dist;
                while inside
                    node = node + dist;
                    if node(1) >=1 && node(1) <= n && node(2) >=1 && node(2) <=m
                        idx = sub2ind([n,m], node(1), node(2));
                        if ~any(antinodes == idx)
                            antinodes = [antinodes, idx];
                        end
                    else
                        inside = false;
                    end
                end

                inside = true;
                node = antenna_1;
                while inside
                    node = node - dist;
                    if node(1) >=1 && node(1) <= n && node(2) >=1 && node(2) <=m
                        idx = sub2ind([n,m], node(1), node(2));
                        if ~any(antinodes == idx)
                            antinodes = [antinodes, idx];
                        end
                    else
                        inside = false;
                    end
                end                
            end
        end
    end
    r = numel(antinodes);
end