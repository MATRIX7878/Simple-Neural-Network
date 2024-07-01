function [] = nnplot(x,y)

axis([-1 1 -1 1])
hold on
%Plot original test data points
scatter(x(y==1,1),x(y==1,2),'m+','DisplayName','Ones') %1 = + on graph
scatter(x(y==0,1),x(y==0,2),'ro','DisplayName','Others') %2-0 = circle on graph
%Set up gradient of errors when enough epochs are ran
% [x1, x2] = meshgrid(-1:.005:1);
% for m = 1:length(x1)
%     for n = 1:width(x2)
%         net(1).x = [1; x1(m,n); x2(m,n)];
%         net = forward(net);
%         z(m,n) = net(length(net)).x(2);
%     end
% end
% contourf(x1,x2,z,[0 .5 .7 .9])
title('Test points'),xlabel('Intensity'),ylabel('Symmetry')
legend
hold off
end