%% Unit test for Linear Transform

% 生成並保存二進制 pattern
num_patterns = 100;
generate_binary_patterns('Linear_in.data', num_patterns);

%% 運算
% 從文件中讀取 pattern 並轉換為 float32
x = read_patterns_and_convert('Linear_in.data', num_patterns);

% 初始化輸出向量
out = zeros(num_patterns, 1);

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
const0_957 = floatToFixedPoint(0.957,N);
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

% 逐個處理每個 x 值
for i = 1:num_patterns
    % 使用 x(i) 進行計算
    if x(i) < const0_6
        val = (x(i) / 16);
    elseif x(i) < const0_64444
        val = (const0_36 * x(i) - const0_180625);
    elseif x(i) < const0_68889
        val = (const0_520625 * x(i) - const0_284375);
    elseif x(i) < const0_73333
        val = (const0_75375 * x(i) - const0_445);
    elseif x(i) < const0_77778
        val = (const1_09125 * x(i) - const0_6925);
    elseif x(i) < const0_82222
        val = (const1_57875 * x(i) - const1_0725);
    elseif x(i) < const0_86667
        val = (const2_285625 * x(i) - const1_65375);
    elseif x(i) < const0_91111
        val = (const3_3075 * x(i) - const2_540625);
    elseif x(i) < const0_95556
        val = (const4_786875 * x(i) - const3_89);
    elseif x(i) <= const1
        val = (const6_94 * x(i) - const5_949375);
    else
        val = (x(i) / 16); % 處理超出範圍的情況
    end

    % 將結果轉換為 float32，並存入 out 向量
    out(i) = single(floatToFixedPoint(val, N));
end

% out 向量現在包含了所有計算結果

%% 寫出 out pattern
% 打開文件準備寫入
fileID = fopen('Linear_out.data', 'w');

% 檢查文件是否成功打開
if fileID == -1
    error('無法打開文件');
end

% 遍歷 out 向量中的每個元素
for i = 1:length(out)
    % 將每個元素轉換為二進制格式
    % 由於沒有整數部分，我們將數值乘以 2^16 並轉換為整數
    fixed_point_number = floor(out(i) * 2^16);

    % 將整數轉換為二進制字符串
    binary_str = dec2bin(fixed_point_number, 16);

    % 將二進制字符串寫入文件
    fprintf(fileID, '%s\n', binary_str);
end

% 關閉文件
fclose(fileID);


%% 用來產生輸入Pattern
function generate_binary_patterns(filename, num_patterns)
    fileID = fopen(filename, 'w');
    if fileID == -1
        error('無法打開文件');
    end
    for i = 1:num_patterns
        random_number = rand();
        fixed_point_number = floor(random_number * 2^8);
        binary_str = dec2bin(fixed_point_number, 9);
        fprintf(fileID, '%s\n', binary_str);
    end
    fclose(fileID);
end

%% 將pattern用浮點方式來表示
function x = read_patterns_and_convert(filename, num_patterns)
    fileID = fopen(filename, 'r');
    if fileID == -1
        error('無法打開文件');
    end
    x = zeros(num_patterns, 1);
    for i = 1:num_patterns
        binary_str = fgetl(fileID);
        fixed_point_number = bin2dec(binary_str);
        x(i) = fixed_point_number / 2^8;
    end
    fclose(fileID);
    x = single(x);
end