clc
clear all

data = readlines("A08.txt");
instructions = arrayfun(@str2num ,regexprep(data{1},{'L','R'},{'2','3'}));
map = regexprep(data(3:end), {'[=(),]', '  '},{'', ' '}).split(' ');

node = "AAA";
step = 0;
while node ~= "ZZZ"
    idx = find(map(:,1) == node);
    node = map(idx, instructions(mod(step,length(instructions))+1));
    step = step+1;
end
disp(['Part 1 solution: ', num2str(step)])

% to solve this we use that also not explicitly given in the exercise text,
% we arrive after a full set of instructions at a terminal node and each
% start node terminates after executing a prime number of instruction sets
nummap = arrayfun(@str2num ,regexprep(map, map(:,1)', cellfun(@num2str, num2cell(1:1:size(map,1)), 'UniformOutput', false)));
sequencemap = nummap(:,1);
for i=1:length(instructions)
    sequencemap = nummap(nummap(:,1), instructions(i));
end
nodesA = nummap(cellfun(@(x) ~isempty(x) ,regexp(map(:,1), 'A$')),1);
terminalnodes = cellfun(@(x) isempty(x) ,regexp(map(:,1), 'Z$'));
lcm = 1;
for i=1:6
    node = nodesA(i);
    step2 = 0;
    while terminalnodes(node) ~= 0
        node = sequencemap(node);
        step2 = step2+1;
    end
    lcm = lcm * step2; 
end
disp(['Part 2 solution: ', num2str(lcm*length(instructions))])







