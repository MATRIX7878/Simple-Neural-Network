function [net] = forward(net)
%Get the length of the neural net
num = length(net);
%Apply forward algorithm
for l = 2:num
    net(l).s = net(l).w'*net(l-1).x; %Get signal of points
    net(l).x = [1; 1./(1+exp(-net(l).s))]; %Apply theta of s
end

end