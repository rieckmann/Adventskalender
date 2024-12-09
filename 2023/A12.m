clc
clear all

data = readlines('A12.txt').split(' ');

T = table(data(:,1),data(:,2), 'VariableNames', ["Sequence", "Defects"]);
T.('SequenceLength') = arrayfun(@strlength, T.Sequence);
T.('NumberOfRequiredDefects') = arrayfun(@(x) sum(double(x.split(',',2))), T.Defects);
T.('NumberOfRequiredGroups') = arrayfun(@(x) numel(x.split(',',2)), T.Defects);
T.('NumberOfExistentGroups') = arrayfun(@(x) numel(regexprep(regexprep(x,'[.]+','.'), '(^[.]|[.]$)', '').split('.',2)), T.Sequence);
T.('SequenceGroups') = arrayfun(@(x) regexprep(regexprep(x,'[.]+','.'), '(^[.]|[.]$)', '').split('.',2), T.Sequence, 'UniformOutput', false);
T.('DefectGroups') = arrayfun(@(x) double(x.split(',',2)), T.Defects, 'UniformOutput', false);
T.('NumberOf#') = arrayfun(@(x) count(x,'#'), T.Sequence);
T.('NumberOf.') = arrayfun(@(x) count(x,'.'), T.Sequence);
T.('NumberOf?') = arrayfun(@(x) count(x,'?'), T.Sequence);
T.('NumberOfMissing#') = T.NumberOfRequiredDefects - T.('NumberOf#');
T.('NumberOfMissing.') = T.('SequenceLength') - T.NumberOfRequiredDefects - T.('NumberOf.');
T.('NumberOfSplitting.') = T.('NumberOfRequiredGroups') - T.('NumberOfExistentGroups');
T.('NumberOfAllPermutations.') = factorial(T.('SequenceLength')-T.('NumberOfRequiredDefects')+1)./(factorial(T.('SequenceLength')-T.('NumberOfRequiredDefects')+1-T.('NumberOfRequiredGroups')).*factorial(T.('NumberOfRequiredGroups')));
T.('Count') = zeros(height(T),1);

% does only work for small example input. The problem is, there can already
% be more then the required groups present. Also one group can contain more
% than one defect group
i = 1;
while i <= height(T)
    row = T(i,:);
    
    if row.('NumberOfSplitting.') == 0 
        valid = prod(strlength(row.('SequenceGroups'){:}) >= row.('DefectGroups'){:});
        if ~valid % filter invalid 
            T(i,:) = [];
            continue;
        end
    end
            
    if row.('NumberOfSplitting.') > 0        
        idx4split = regexp(row.Sequence, '(?<=[^.]{1})[?]{1}(?=[^.]{1})');
        for j=1:numel(idx4split)
            rowAdd = row;
            rowAdd.Sequence = row.Sequence;
            rowAdd.Sequence{1}(idx4split(j)) = '.';
            rowAdd.('NumberOf.') = rowAdd.('NumberOf.') + 1;
            rowAdd.('NumberOfMissing.') = rowAdd.('NumberOfMissing.') - 1;
            rowAdd.('NumberOfSplitting.') = rowAdd.('NumberOfSplitting.') - 1;
            rowAdd.('SequenceGroups') = arrayfun(@(x) regexprep(regexprep(x,'[.]+','.'), '(^[.]|[.]$)', '').split('.',2), rowAdd.Sequence, 'UniformOutput', false);
            if ~any(T.Sequence == rowAdd.Sequence) % only add unique
                T = [T;rowAdd];
            end
        end
        T(i,:) = [];
    else        
        if row.('NumberOfMissing.') > 0
            idx4split = unique([regexp(row.Sequence, '^[?]{1}[?#]+'),regexp(row.Sequence,'(?<=[?#]+)[?]{1}$'),regexp(row.Sequence,'(?<=[?#]+)[?]{1}[.]{1}'),regexp(row.Sequence,'(?<=[.]{1})[?]{1}[?#]+')]); % WHY NOT WORKING????
            for j=1:numel(idx4split)
                rowAdd = row;
                rowAdd.Sequence = row.Sequence;
                rowAdd.Sequence{1}(idx4split(j)) = '.';
                rowAdd.('NumberOf.') = rowAdd.('NumberOf.') + 1;
                rowAdd.('NumberOfMissing.') = rowAdd.('NumberOfMissing.') - 1;
                rowAdd.('SequenceGroups') = arrayfun(@(x) regexprep(regexprep(x,'[.]+','.'), '(^[.]|[.]$)', '').split('.',2), rowAdd.Sequence, 'UniformOutput', false);
                if ~any(T.Sequence == rowAdd.Sequence) % only add unique
                    T = [T;rowAdd];
                end
            end
            T(i,:) = [];
        else
            row.Sequence = regexprep(row.Sequence,'?','#');
            row.('Count') = 1;
            T(i,:) = row;
            i = i+1;
        end
    end         
end
result = sum(T.Count);
disp(['Part 1 solution: ', num2str(result)])

