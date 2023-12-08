clc
clear all

data = readlines("A08.txt");
tic
instructions = arrayfun(@str2num ,regexprep(data{1},{'L','R'},{'2','3'}));
map = regexprep(data(3:end), {'[=(),]', '  '},{'', ' '}).split(' ');
nummap = [(1:1:size(map,1))', arrayfun(@(x) find(map(:,1)==x),map(:,2)), arrayfun(@(x) find(map(:,1)==x),map(:,3))];
L = length(instructions);

sequencemap = nummap(:,1);
for i=1:length(instructions)
    sequencemap = nummap(nummap(:,1), instructions(i));
end

idx = find(map(:,1) == "AAA");
terminalidx = find(map(:,1) == "ZZZ");
step = 0;
while idx ~= terminalidx
    idx = sequencemap(idx);
    step = step+1;
end
disp(['Part 1 solution: ', num2str(step*L)])

% to solve this we use that also not explicitly given in the exercise text,
% we arrive after a full set of instructions at a terminal node and each
% start node terminates after executing a prime number of instruction sets
nodesA = nummap(cellfun(@(x) ~isempty(x) ,regexp(map(:,1), 'A$')),1);
terminalnodes = cellfun(@(x) isempty(x) ,regexp(map(:,1), 'Z$'));
iter = 1;
for i=1:size(nodesA,1)
    node = nodesA(i);
    step2 = 0;
    while terminalnodes(node) ~= 0
        node = sequencemap(node);
        step2 = step2+1;
    end
    iter = lcm(step2, iter); 
end
disp(['Part 2 solution: ', num2str(iter*length(instructions))])
toc






