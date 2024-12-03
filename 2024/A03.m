clc
clear all
close all

file = fopen('A03.txt');

line = fgetl(file);
i = 1;
data = '';
while line ~= -1
    data = [data, line];
    i = i+1;
    line = fgetl(file);
end

adventdriver(@part1, data);

adventdriver(@part2, data);

fclose(file);

function r = part1(data)
    r = 0;    
    nums = regexp(data, 'mul\((\d{1,3}),(\d{1,3})\)','tokens');
    for i=1:numel(nums)
       r = r + str2num(nums{1,i}{1,1}) * str2num(nums{1,i}{1,2});
    end
    
end

function r = part2(data)
    r = 0;
    do = true;    
    while numel(data) > 0
        if do
            data = regexp(data,'don''t\(\)','split','once');
            do = false;
            
            nums = regexp(data{1,1}, 'mul\((\d{1,3}),(\d{1,3})\)','tokens');
            for i=1:numel(nums)
                r = r + str2num(nums{1,i}{1,1}) * str2num(nums{1,i}{1,2});
            end
            
            if numel(data) > 1
                data = data{1,2};
            else
                data = cell(0,0);
            end            
        else
            data = regexp(data,'do\(\)','split','once');  
            do = true;
            if numel(data) > 1
               data = data{1,2};
            else
                data = cell(0,0);
            end 

        end   
    end

end