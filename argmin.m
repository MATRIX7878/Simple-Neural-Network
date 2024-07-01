function [eta] = argmin(net,x,y)
%Set up initial etas and epsilon
epsilon = .1;
etas = [0 epsilon 0 0];
error = [0 0 0 0];
%Get square mean error
error(1) = sqr(net,etas(1),x,y);
error(2) = sqr(net,etas(2),x,y);
%If next error is lower than current
if error(2) < error(1)
    etas(3) = 2 * etas(2);
%If next error is greater than current
else
    etas = [etas(2) 0 -epsilon 0];
end
%Get square error for etas(3)
error(3) = sqr(net,etas(3),x,y);
%Update etas as long as the error on etas(3) is less than the error on etas(2)
while error(3) < error(2)
    etas = [etas(2) etas(3) 2*etas(3) 0];
    %Update error(3) with new etas
    error(3) = sqr(net,etas(3),x,y);
end
%While within a tolerance and less than a certain iteration
%update all the errors to get best eta
p = 1;
while abs(etas(3)-etas(1)) > .01 && p < 20
    %Get etas(4) and error(4)
    etas(4) = .5 * (etas(1) + etas(3));
    error(4) = sqr(net,etas(4),x,y);
    %Update errors if new eta is present  
    %If average eta is lower than center eta
    if etas(4) < etas(2)
        %If error in etas(4) is lower than error in etas(2)
        if error(4) < error(2)
            etas = [etas(1) etas(4) etas(2) etas(4)];
            error(2) = sqr(net,etas(2),x,y);
        %If error in etas(4) is greater than error in etas(2)
        elseif error(4) > error(2)
            etas = [etas(4) etas(2) etas(3) etas(4)];
        end
    %If average eta is greater than center eta
    elseif etas(4) > etas(2)
        %If error in etas(4) is lower than error in etas(2)
        if error(4) < error(2)
            etas = [etas(2) etas(4) etas(3) etas(4)];
            error(2) = sqr(net,etas(2),x,y);
        %If error in etas(4) is greater than error in etas(2)
        elseif error(4) > error(2)
            etas = [etas(1) etas(2) etas(4) etas(4)];
            etas(3) = etas(4);            
        end
    %Uh oh, they are the same.  Randomly update etas(4).
    else
        k = randi(10);
        if mod(k,2) == 0
            etas(4) = etas(4) * 1.05;
        else
            etas(4) = etas(4) / 1.05;
        end
    end
    p = p + 1;
end           
%return median eta as eta
eta = etas(4);

end