function [Ein,net] = neuralrun(net,y)
%Initialzie variables
L = length(net);
%Do forward and back propagation
[net] = forward(net);
[net] = backward(net,y);
%Get Ein
Ein = 1/2 * (net(L).x(2) - y).^2;
for l = 2:L
    net(l).G = net(l-1).x * net(l).delta'; %Get gradient of error
end
end