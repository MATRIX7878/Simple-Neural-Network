function [error] = neuraltest(net,x,y)
%Initialize error counter and constants
j = 1;
N = length(y);
num = length(net);
%See how many points in testing data are outside trained line area
for i = 1:N
    %Set up test to get probability of 1 or 0
    net(1).x = [1; x(i,:)'];
    net = forward(net); %Get probability
    net(num).x(1) = []; %Remove bias
    %Chance that the value is 1 is less than 50%
    if net(num).x < .5
        a = 0;
    %Chance that the value is 1 is greater than 50%
    elseif net(num).x > .5
        a = 1;
    %Rare but possible chance that the network cannot make up its mind,
    %randomly choose a value and go with it.
    else
        a = randi([0 1]);
    end
    %If the value actually is 1
    if a ~= y(i)
        n(j,:) = x(i,:); %Where value is wrong
        j = j + 1;
    end
end
%Return average error
error = j/N;
%Plot highlight the misclassified
scatter(n(:,1),n(:,2),'kp','DisplayName','Misclassified') %pentagram on graph

end