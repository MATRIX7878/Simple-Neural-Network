function [err] = sqr(net,eta,x,y)
%Initialize the constants
err = 0;
n = length(x);
L = length(net);
%Update the weights
for l = 2:L
    net(l).w = net(l).w - eta * net(l).V;
end
%Get the square mean error and return it
for i = 1:n
    net(1).x = [1; x(i,:)'];
    net = forward(net);
    e_n = .5 * (net(L).x(2:end) - y(i,:)').^2;
    err = err + e_n./n;
end