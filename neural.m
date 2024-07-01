%Load in data
load usps_modified.mat
%Extract data points
[x0,y0]=getfeatures(data);
y0(y0~=1) = 0;
[~, dim] = size(x0);
%Get the users parameters
descent = input(['How would you like to use the neural network?  Batch with '...
    'constant eta(b), stochastic (s), variable (v), or steepest (e) '],'s');
hidden = input('How many hidden layers are required? ');
%Setup how many nodes will be in each layer
for i = 1:hidden + 2
    if i == 1 %Input layer
        str = sprintf('I have detected %d number of inputs (with leading ones)',dim + 1);
        disp(str)
        d(i) = dim + 1;
    elseif i > 1 && i < hidden + 2 %Hidden layers
        fprintf('How many nodes are there for hidden layer %d (include leading 1)? ',i-1)
        d(i) = input('');
    else %Output layer
        str = sprintf('I have detected that there should be %d number of outputs',width(y0));
        disp(str)
        d(i) = width(y0);
    end
end
%Setup the neural network structure and get it's length
network(1:length(d),1) = struct;
len = length(network);
for b = 1:10
    %Get random assortment of numbers
    r = randperm(5000);
    %Get training and testing data
    xtrain=x0(r(1:4000),:);
    ytrain=y0(r(1:4000));
    xtest=x0(r(4001:5000),:);
    ytest=y0(r(4001:5000));
    x = length(xtrain);
    %Get constant eta value and initialize epochs
    eta = .1;
    t = 1;
    %Setup random weights for each layer minus output layer
    for j = 2:hidden + 2
        if j == 2 || j < hidden + 2
            network(j).w = rand(d(j-1),d(j) - 1);
        else
            network(j).w = rand(d(j-1),d(j));
        end
    end
    %Start weight update
    while t < 100
        switch descent
            case 's' %Stochastic update.  Almost same as batch, except weights are
                        %updated after every point is ran.
                for k = 1:x
                    network(1).x = [1; xtrain(k,:)'];
                    [ein(k),network] = neuralrun(network,ytrain(k)); %Stochastic mode
                    for l = 2:len
                        network(l).w = network(l).w - eta * network(l).G;
                    end
                end
            case {'b','v','e'} %All batch style methods
                %Run main batch code
                for k = 1:x
                    %For every xtrain data set
                    network(1).x = [1; xtrain(k,:)']; %Add bias
                    [ein(k),network] = neuralrun(network,ytrain(k)); %Batch mode
                    %Get gradient of errors
                    for l = 2:length(network)
                        if k == 1
                            network(l).V = network(l).G ./ length(x);
                        else
                            network(l).V = network(l).V + network(l).G ./ length(x);
                        end
                    end
                end
                switch descent
                    case 'v' %Variable learning rate update
                        %Set up Eold as a place holder
                        Eold(t) = ein(t);
                        %Only difference between batch and this is that eta is
                        %being updated by the variable method
                        eta = neuralvariable(ein(t + 1), Eold(t), eta);
                    case 'e' %Steepest descent method.  Same comments as batch
                        %Only difference from batch is this line performing
                        %bisection updating
                        eta = argmin(network,xtrain,ytrain);
                end
            %Update weights
            for a = 2:len
                network(a).w = network(a).w - eta * network(a).V;
            end
            %User puts in bad option
            otherwise
                disp('That is not a weight option.') %Bad input
                return
        end
    %See how accurate you are
    error(b) = neuraltest(network,xtest,ytest);
    %Update epoch
    t = t + 1;
    end
    %Get average of Ein for each fold
    en(b) = mean(ein);
    eout(b) = mean(error);
end
%Plot everything
nnplot(xtest,ytest)
%Get final errors
Ein = mean(en)
Eout = mean(eout)
%Get a plot of all errors over the iterations of the code
figure
a = 1:10;
plot(a,eout,'o')
title('Error vs Iterations'),xlabel('Trials'),ylabel('Error')