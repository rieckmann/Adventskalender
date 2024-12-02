function [ r, t ] = adventdriver( delegate, input )
%Driver function, executes and measures a function and displays the result

tic
r = delegate(input);
t = toc;

disp(['Result is : ', num2str(r)]);
disp(['Computation took : ', num2str(t), 's']);

end

