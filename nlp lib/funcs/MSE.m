function output = MSE(predicted, actual)
 output = mean(sum(((predictions-actual).^2)'));
end
