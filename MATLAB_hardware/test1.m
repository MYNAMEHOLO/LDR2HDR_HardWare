val = computeValue(1)

function val = computeValue(x)
    % 定義定點數格式
    F = fimath('RoundingMethod', 'Floor', ...
               'OverflowAction', 'Saturate', ...
               'ProductMode', 'SpecifyPrecision', ...
               'ProductWordLength', 16, ...
               'ProductFractionLength', 12, ...
               'SumMode', 'SpecifyPrecision', ...
               'SumWordLength', 16, ...
               'SumFractionLength', 12);

    % 量化輸入值
    x = fi(x, 1, 16, 12, F);

    % 以下是原有的邏輯運算
    if x < 0.6
        val = x / 16;
    elseif x < 0.64444
        val = (0.36 * x) - 0.180625;
    elseif x < 0.68889
        val = (0.520625 * x) - 0.284375; 
    elseif x < 0.73333
        val = (0.75375 * x) - 0.445;
    elseif x < 0.77778
        val = (1.09125 * x) - 0.6925;
    elseif x < 0.82222
        val = (1.57875 * x) - 1.0725;
    elseif x < 0.86667
        val = (2.285625 * x) - 1.65375;
    elseif x < 0.91111
        val = (3.3075 * x) - 2.540625;
    elseif x < 0.95556
        val = (4.786875 * x) - 3.89;
    elseif x <= 1
        val = (6.94 * x) - 5.949375;
    else
        val = x / 16; % 處理超出範圍的情況
    end

    % 量化輸出值
    val = fi(val, 1, 16, 12, F);
end
