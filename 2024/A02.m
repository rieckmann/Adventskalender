clc
clear all
close all



adventdriver(@part1, data);

adventdriver(@part2, data);

fclose(file);

function r = part1(data)

r = 0;
for i=1:numel(data)
    line = data{i,1};
    if check(line)
        r = r+1;
    end
end

end

function r = part2(data)

r = 0;
for i=1:numel(data)
    line = data{i,1};
    if check(line)
        r = r + 1;
    else
        for j=1:numel(line)
            newline = line([1:j-1 j+1:end]);            
            if check(newline)
                r = r + 1;
                break;
            end
        end
    end
end

end

function r = check(line)
    r = false;
    diff = line(2:end)-line(1:end-1);
    mini = min(diff);
    maxi = max(diff);
    if mini*maxi > 0 && max(abs(mini),abs(maxi)) <= 3
        r = true;
    end
end
