%% 這支函數是用來將Kernel的weighting數值轉換成為定點數的function
function kernel = convertToFixedPoint(kernel, fractionLength)
    for i = 1:size(kernel, 1)
        for j = 1:size(kernel, 2)
            kernel(i, j) = floatToFixedPoint(kernel(i, j), fractionLength);
        end
    end
end