function fixedPointNumber = floatToFixedPoint(floatNumber, fractionLength)
    % floatToFixedPoint - 将浮点数转换为定点数并返回为 single 类型
    % 对于正数使用 floor 函数，对于负数使用 ceil 函数
    % 输入:
    %   floatNumber - 输入的浮点数
    %   fractionLength - 定点数的小数长度

    % 计算缩放因子
    scaleFactor = 2^fractionLength;

    % 对正数使用 floor，对负数使用 ceil
    if floatNumber >= 0
        scaledNumber = floor(floatNumber * scaleFactor);
    else
        scaledNumber = ceil(floatNumber * scaleFactor);
    end

    % 转换回浮点数并转换为 single 类型
    fixedPointNumber = single(scaledNumber / scaleFactor);
end
