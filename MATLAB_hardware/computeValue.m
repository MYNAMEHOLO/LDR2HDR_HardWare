%% Function for linear Transform and normalize
function val = computeValue(x)
    % 確保輸入值為 float32
    % N = 精度取到小數點後第幾位
    N = 16;
    x = single(x);
    %%转换所有常数
    const0_6 = floatToFixedPoint(0.6,N);
    const0_64444 = floatToFixedPoint(0.64444,N);
    const0_68889 = floatToFixedPoint(0.68889,N);
    const0_73333 = floatToFixedPoint(0.73333,N);
    const0_77778 = floatToFixedPoint(0.77778,N);
    const0_82222 = floatToFixedPoint(0.82222,N);
    const0_86667 = floatToFixedPoint(0.86667,N);
    const0_91111 = floatToFixedPoint(0.91111,N);
    const0_95556 = floatToFixedPoint(0.95556,N);
    const1 = floatToFixedPoint(1,N);

    % 转换所有乘数和加数
    const0_36 = floatToFixedPoint(0.36,N);
    const0_180625 = floatToFixedPoint(0.180625,N);
    const0_520625 = floatToFixedPoint(0.520625,N);
    const0_284375 = floatToFixedPoint(0.284375,N);
    const0_75375 = floatToFixedPoint(0.75375,N);
    const0_445 = floatToFixedPoint(0.445,N);
    const1_09125 = floatToFixedPoint(1.09125,N);
    const0_6925 = floatToFixedPoint(0.6925,N);
    const1_57875 = floatToFixedPoint(1.57875,N);
    const1_0725 = floatToFixedPoint(1.0725,N);
    const2_285625 = floatToFixedPoint(2.285625,N);
    const1_65375 = floatToFixedPoint(1.65375,N);
    const3_3075 = floatToFixedPoint(3.3075,N);
    const2_540625 = floatToFixedPoint(2.540625,N);
    const4_786875 = floatToFixedPoint(4.786875,N);
    const3_89 = floatToFixedPoint(3.89,N);
    const6_94 = floatToFixedPoint(6.94,N);
    const5_949375 = floatToFixedPoint(5.949375,N);

    % 应用条件逻辑
    if x < const0_6
        val = (x / 16);
    elseif x < const0_64444
        val = (const0_36 * x - const0_180625);
    elseif x < const0_68889
        val = (const0_520625 * x - const0_284375);
    elseif x < const0_73333
        val = (const0_75375 * x - const0_445);
    elseif x < const0_77778
        val = (const1_09125 * x - const0_6925);
    elseif x < const0_82222
        val = (const1_57875 * x - const1_0725);
    elseif x < const0_86667
        val = (const2_285625 * x - const1_65375);
    elseif x < const0_91111
        val = (const3_3075 * x - const2_540625);
    elseif x < const0_95556
        val = (const4_786875 * x - const3_89);
    elseif x <= const1
        val = (const6_94 * x - const5_949375);
    else
        val = (x / 16); % 处理超出范围的情况
    end
    val = single(floatToFixedPoint(val,N)) ;
end