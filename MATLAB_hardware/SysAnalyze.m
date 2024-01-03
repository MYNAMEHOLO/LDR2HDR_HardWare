%% Project LDR 2 HDR
% 特別注意所有數值必須要以 float32(single)來進行處理。

%% 讀取圖片
% 假设文件名是从 '3.hdr' 到 '10.hdr'
for fileNum = 3:10
    % 构建当前图片的文件名
    filename = sprintf('../golden/LDR/%d.hdr', fileNum);


% 讀取LDR影像
ldr_src = hdrread(filename);
ldr_src = single(ldr_src); % 转换为 float32

% 顯示讀入的圖片
%imshow(ldr_src);

% 分離R,G,B三個通道
ldr_src_R = ldr_src(:,:,1);
ldr_src_G = ldr_src(:,:,2);
ldr_src_B = ldr_src(:,:,3);
    
% 顯示這張圖片的三種顏色通道 
%figure, imshow(ldr_src_R), title('Red Channel');
%figure, imshow(ldr_src_G), title('Green Channel');
%figure, imshow(ldr_src_B), title('Blue Channel');

%% Zero Padding
% 定義要添加的零的數量（每邊一個）
paddingSize = 1;

% 對 R, G, B 通道進行 zero padding
ldr_src_R_padded = padarray(ldr_src_R, [paddingSize paddingSize], 0, 'both');
ldr_src_G_padded = padarray(ldr_src_G, [paddingSize paddingSize], 0, 'both');
ldr_src_B_padded = padarray(ldr_src_B, [paddingSize paddingSize], 0, 'both');

% 确保 padded 后的数组也是 float32
ldr_src_R_padded = single(ldr_src_R_padded);
ldr_src_G_padded = single(ldr_src_G_padded);
ldr_src_B_padded = single(ldr_src_B_padded);

%% 近似轉換並切割

% 將原圖進行線性轉換
src_linear_R = single(arrayfun(@computeValue, ldr_src_R_padded));
src_linear_G = single(arrayfun(@computeValue, ldr_src_G_padded));
src_linear_B = single(arrayfun(@computeValue, ldr_src_B_padded));

% 获取每个通道的行和列数（考虑到了 padding）
[rows_linear, cols_linear] = size(ldr_src_R_padded);

% 初始化用于存储切割块的 cell 数组
blocks_linear_R = {};
blocks_linear_G = {};
blocks_linear_B = {};

% 从第 2 行第 2 列开始，到倒数第 2 行第 2 列结束
for k = 2:(rows_linear-1)
    for w = 2:(cols_linear-1)
        % 提取 3x3 块
        % 線性轉換的部分
        block_linear_R = src_linear_R(k-1:k+1, w-1:w+1);
        block_linear_G = src_linear_G(k-1:k+1, w-1:w+1);
        block_linear_B = src_linear_B(k-1:k+1, w-1:w+1);

        % 将块存储到 cell 数组中
        blocks_linear_R{end+1} = single(block_linear_R);
        blocks_linear_G{end+1} = single(block_linear_G);
        blocks_linear_B{end+1} = single(block_linear_B);
    end
end
%% 检查特定的 linear block数值
%{
% 假设原始图像大小为 MxN
M = 1080; % 实际行数
N = 1920; % 实际列数

%   列
% 行
%
%
% 指定要检查的行和列
real_targetRow = 829;
real_targetCol = 1398;

% 计算在 cell 数组中的索引
index_linear = ((real_targetRow - 1) * N) + real_targetCol;

% 检查 R 通道中 3x3 块的数值
block_linear_R = blocks_linear_R{index_linear};
fprintf('Linear Block from linear transformed R Channel at Row = %d, Col = %d:\n', real_targetRow, real_targetCol);
disp(block_linear_R);

% 检查 G 通道中 3x3 块的数值
block_linear_G = blocks_linear_G{index_linear};
fprintf('Linear Block from linear transformed G Channel at Row = %d, Col = %d:\n', real_targetRow, real_targetCol);
disp(block_linear_G);

% 检查 B 通道中 3x3 块的数值
block_linear_B = blocks_linear_B{index_linear};
fprintf('Linear Block from linear transformed B Channel at Row = %d, Col = %d:\n', real_targetRow, real_targetCol);
disp(block_linear_B);
%}

%% 製作線性轉換並normalized的 3x3 cell
% 初始化 normalized blocks cell arrays
blocks_normalized_R = cell(size(blocks_linear_R));
blocks_normalized_G = cell(size(blocks_linear_G));
blocks_normalized_B = cell(size(blocks_linear_B));

% 定義一個匿名函數來執行除法操作
% 除16的部分我在linear轉換就做掉了,這邊只是懶得改去串API,請忽略變數名稱吧。
divideBy16 = @(block) single(block) ;

% 針對 R 通道進行除法並存儲結果
blocks_normalized_R = cellfun(divideBy16, blocks_linear_R, 'UniformOutput', false);

% 針對 G 通道進行除法並存儲結果
blocks_normalized_G = cellfun(divideBy16, blocks_linear_G, 'UniformOutput', false);

% 針對 B 通道進行除法並存儲結果
blocks_normalized_B = cellfun(divideBy16, blocks_linear_B, 'UniformOutput', false);

%% 檢查特定的 normalized block 數值
%{
% 假设原始图像大小为 MxN
M = 1080; % 实际行数
N = 1920; % 实际列数

% 指定要检查的行和列
real_targetRow = 829;
real_targetCol = 1398;

% 计算在 cell 数组中的索引
index = ((real_targetRow - 1) * N) + real_targetCol;

% 检查 normalized R 通道中的 3x3 块的数值
block_normalized_R = blocks_normalized_R{index};
fprintf('Normalized Block you find from R Channel at Row = %d, Col = %d:\n', real_targetRow, real_targetCol);
disp(block_normalized_R);

% 检查 normalized G 通道中的 3x3 块的数值
block_normalized_G = blocks_normalized_G{index};
fprintf('Normalized Block you find from G Channel at Row = %d, Col = %d:\n', real_targetRow, real_targetCol);
disp(block_normalized_G);

% 检查 normalized B 通道中的 3x3 块的数值
block_normalized_B = blocks_normalized_B{index};
fprintf('Normalized Block you find from B Channel at Row = %d, Col = %d:\n', real_targetRow, real_targetCol);
disp(block_normalized_B);
%}
%% 將原始影像切割成3x3的cell
% 获取每个通道的行和列数（考虑到了 padding）
[rows, cols] = size(ldr_src_R_padded);

% 初始化用于存储切割块的 cell 数组
blocks_src_R = {};
blocks_src_G = {};
blocks_src_B = {};

% 从第 2 行第 2 列开始，到倒数第 2 行第 2 列结束
for i = 2:(rows-1)
    for j = 2:(cols-1)
        % 提取 3x3 块
        block_src_R = ldr_src_R_padded(i-1:i+1, j-1:j+1);
        block_src_G = ldr_src_G_padded(i-1:i+1, j-1:j+1);
        block_src_B = ldr_src_B_padded(i-1:i+1, j-1:j+1);

        % 将块存储到 cell 数组中
        blocks_src_R{end+1} = single(block_src_R);
        blocks_src_G{end+1} = single(block_src_G);
        blocks_src_B{end+1} = single(block_src_B);
    end
end
%% 檢查特定的src block數值
%{
% 這段程式可以用來debug檢查特定的src block數值並print出來 (Debug用)
% 假设原始图像大小为 MxN
M = 1080; % 实际行数
N = 1920; % 实际列数

%   列
% 行
%
%
% 指定要检查的行和列
real_targetRow_src = 829 ;
real_targetCol_src = 1398 ;

% 计算在 cell 数组中的索引
index_src = ((real_targetRow_src - 1) * N ) +  real_targetCol_src;

% 检查 R 通道中 3x3 块的数值
block_you_find_R = blocks_src_R{index_src};
fprintf('Src Block you find from R Channel at Row = %d, Col = %d:\n', real_targetRow_src, real_targetCol_src);
disp(block_you_find_R);

% 检查 G 通道中 3x3 块的数值
block_you_find_G = blocks_src_G{index_src};
fprintf('Src Block you find from G Channel at Row = %d, Col = %d:\n', real_targetRow_src, real_targetCol_src);
disp(block_you_find_G);

% 检查 B 通道中 3x3 块的数值
block_you_find_B = blocks_src_B{index_src};
fprintf('Src Block you find from B Channel at Row = %d, Col = %d:\n', real_targetRow_src, real_targetCol_src);
disp(block_you_find_B);
%}


%% 進行每個cell block的分類判斷並輸出到三個不同的向量之中
% 獲取每個通道的 block 數量
numBlocks_R = length(blocks_src_R);
numBlocks_G = length(blocks_src_G);
numBlocks_B = length(blocks_src_B);

% 確保所有通道的 block 數量相同
if numBlocks_R ~= numBlocks_G || numBlocks_R ~= numBlocks_B
    error('The number of blocks in each channel must be the same.');
end

% 初始化存儲分類結果的向量
classification_results = zeros(1, numBlocks_R);

% 逐個處理每個 block
for i = 1:numBlocks_R
    % 獲取當前的 R, G, B blocks
    currentBlock_R = blocks_src_R{i};
    currentBlock_G = blocks_src_G{i};
    currentBlock_B = blocks_src_B{i};

    % 使用 processCells 函數進行分類
    classification_results(i) = processCells(currentBlock_R, currentBlock_G, currentBlock_B);
end

%% 檢查 class_output 的部分 (目前暫定一次檢查10000筆)
%{
if length(classification_results) >= 10000
    disp(classification_results(1:10000))
else
    disp('classification_results contains fewer than 10000 elements.')
end
%}

% 假设 classification_results 已经定义
output_RGB_1_pxl = cell(1, 2073600); % 预分配一个 cell 数组



%% 進CONV並吐出 output_RGB_1_pxl 的數值組
for i = 1:2073600
    if classification_results(i) == 0
        output_RGB_1_pxl{i} = ROAD0(blocks_normalized_R{i}, blocks_normalized_G{i}, blocks_normalized_B{i});
    elseif classification_results(i) == 1
        output_RGB_1_pxl{i} = ROAD1(blocks_normalized_R{i}, blocks_normalized_G{i}, blocks_normalized_B{i});
    elseif classification_results(i) == 2
        output_RGB_1_pxl{i} = ROAD2(blocks_normalized_R{i}, blocks_normalized_G{i}, blocks_normalized_B{i});
    elseif classification_results(i) == 3
        output_RGB_1_pxl{i} = ROAD3(blocks_normalized_R{i}, blocks_normalized_G{i}, blocks_normalized_B{i});
    else
        output_RGB_1_pxl{i} = ROAD4(blocks_normalized_R{i}, blocks_normalized_G{i}, blocks_normalized_B{i});
    end
end

%% 重組圖片
% 初始化重组图像的矩阵
reconstructed_image = zeros(1080, 1920, 3);

% 遍历 output_RGB_1_pxl 中的每个 cell
for i = 1:numel(output_RGB_1_pxl)
    % 计算当前像素在图像中的位置
    row = floor((i - 1) / 1920) + 1;
    col = mod(i - 1, 1920) + 1;

    % 将 RGB 向量放置在图像的正确位置
    reconstructed_image(row, col, :) = output_RGB_1_pxl{i};
end

% 保存图像为 HDR 格式
    output_filename = sprintf('../output_matlab_hardware/HDR/%d_output.hdr', fileNum);
    hdrwrite(reconstructed_image, output_filename);
end

