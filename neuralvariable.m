function [eta] = neuralvariable(Ein, Eold, eta)
%Create variables
a = 1.075;
b = .65;
%Get previous weight to check against current and update as needed
if Eold > Ein
    eta = a * eta;
else
    eta = b * eta;
end
end