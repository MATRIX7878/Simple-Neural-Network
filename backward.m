function [net] = backward(net,y)
%Get length of network
num = length(net);
%Get rid of bias values
x = net(num).x(2:end);
%Calculate last delta node for back prop
net(num).delta = (x-y).*x.*(1-x);
%Work backwards until 1st node getting sensitivity
for l = num-1:-1:2
    x = net(l).x(2:end); %Setup x's
    w = net(l+1).w(2:end); %Setup w's
    net(l).delta = x.*(1-x).*(w*(net(l+1).delta));
end

end