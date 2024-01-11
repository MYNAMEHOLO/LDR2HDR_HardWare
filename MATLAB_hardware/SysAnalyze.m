%% Project LDR 2 HDR
% 特别注意所有数值必须要以 float32(single)来进行处理。

%% 读取图片
for fileNum = 1:13
    % 构建当前图片的文件名
    filename = sprintf('../golden/LDR/%d.hdr', fileNum);

    % 读取LDR影像
    ldr_src = hdrread(filename);
    ldr_src = single(ldr_src); % 转换为 float32

    % 获取图像尺寸
    [rows, cols, ~] = size(ldr_src);

    % 分离R,G,B三个通道
    ldr_src_R = ldr_src(:,:,1);
    ldr_src_G = ldr_src(:,:,2);
    ldr_src_B = ldr_src(:,:,3);

    %% 将输入影像先进行定点(定点到二进制的小数点后8bit)
    fractionLength = 8; % 例如，这里定义小数长度为 8
    ldr_src_R = arrayfun(@(x) floatToFixedPoint(x, fractionLength), ldr_src_R);
    ldr_src_G = arrayfun(@(x) floatToFixedPoint(x, fractionLength), ldr_src_G);
    ldr_src_B = arrayfun(@(x) floatToFixedPoint(x, fractionLength), ldr_src_B);

    %% Zero Padding
    % 定义要添加的零的数量（每边一个）
    paddingSize = 1;

    % 对 R, G, B 通道进行 zero padding
    ldr_src_R_padded = padarray(ldr_src_R, [paddingSize paddingSize], 0, 'both');
    ldr_src_G_padded = padarray(ldr_src_G, [paddingSize paddingSize], 0, 'both');
    ldr_src_B_padded = padarray(ldr_src_B, [paddingSize paddingSize], 0, 'both');

    % 确保 padded 后的数组也是 float32
    ldr_src_R_padded = single(ldr_src_R_padded);
    ldr_src_G_padded = single(ldr_src_G_padded);
    ldr_src_B_padded = single(ldr_src_B_padded);

    %% 近似转换并切割
    % 将原图进行线性转换
    src_linear_R = single(arrayfun(@computeValue, ldr_src_R_padded));
    src_linear_G = single(arrayfun(@computeValue, ldr_src_G_padded));
    src_linear_B = single(arrayfun(@computeValue, ldr_src_B_padded));

    % 获取每个通道的行和列数（考虑到了 padding）
    [rows_padded, cols_padded] = size(ldr_src_R_padded);

    % 初始化用于存储切割块的 cell 数组
    blocks_linear_R = cell((rows_padded - 2) * (cols_padded - 2), 1);
    blocks_linear_G = cell(size(blocks_linear_R));
    blocks_linear_B = cell(size(blocks_linear_R));

    % 从第 2 行第 2 列开始，到倒数第 2 行第 2 列结束
    idx = 1;
    for k = 2:(rows_padded - 1)
        for w = 2:(cols_padded - 1)
            % 提取 3x3 块
            block_linear_R = src_linear_R(k - 1:k + 1, w - 1:w + 1);
            block_linear_G = src_linear_G(k - 1:k + 1, w - 1:w + 1);
            block_linear_B = src_linear_B(k - 1:k + 1, w - 1:w + 1);

            % 将块存储到 cell 数组中
            blocks_linear_R{idx} = block_linear_R;
            blocks_linear_G{idx} = block_linear_G;
            blocks_linear_B{idx} = block_linear_B;
            idx = idx + 1;
        end
    end

    %% 进行每个cell block的分类判断并输出到三个不同的向量之中
    numBlocks = numel(blocks_linear_R);
    classification_results = zeros(1, numBlocks);

    for i = 1:numBlocks
        currentBlock_R = blocks_linear_R{i};
        currentBlock_G = blocks_linear_G{i};
        currentBlock_B = blocks_linear_B{i};

        classification_results(i) = processCells(currentBlock_R, currentBlock_G, currentBlock_B);
    end

    %% 進CONV並吐出 output_RGB_1_pxl 的数值组
    output_RGB_1_pxl = cell(1, numBlocks);
    for i = 1:numBlocks
        if classification_results(i) == 0
            output_RGB_1_pxl{i} = ROAD0(blocks_linear_R{i}, blocks_linear_G{i}, blocks_linear_B{i});
        elseif classification_results(i) == 1
            output_RGB_1_pxl{i} = ROAD1(blocks_linear_R{i}, blocks_linear_G{i}, blocks_linear_B{i});
        elseif classification_results(i) == 2
            output_RGB_1_pxl{i} = ROAD2(blocks_linear_R{i}, blocks_linear_G{i}, blocks_linear_B{i});
        elseif classification_results(i) == 3
            output_RGB_1_pxl{i} = ROAD3(blocks_linear_R{i}, blocks_linear_G{i}, blocks_linear_B{i});
        else
            output_RGB_1_pxl{i} = ROAD4(blocks_linear_R{i}, blocks_linear_G{i}, blocks_linear_B{i});
        end
    end

    %% 重組圖片
    reconstructed_image = zeros(rows, cols, 3);

    for i = 1:numBlocks
        row = floor((i - 1) / cols) + 1;
        col = mod(i - 1, cols) + 1;
        reconstructed_image(row, col, :) = output_RGB_1_pxl{i};
    end

    % 保存图像为 HDR 格式
    output_filename = sprintf('../output_matlab_hardware/HDR/%d_output.hdr', fileNum);
    hdrwrite(reconstructed_image, output_filename);
end
