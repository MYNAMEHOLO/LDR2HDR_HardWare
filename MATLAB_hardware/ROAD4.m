%% for weight c4
function [output_onepxl_combined] = ROAD4(input_cell_R,input_cell_G,input_cell_B)
    output_onepxl_combined = zeros(1, 3);
    %% Define medium origin cell
    medium_pxl_origin_R = single(input_cell_R(2,2));
    medium_pxl_origin_G = single(input_cell_G(2,2));
    medium_pxl_origin_B = single(input_cell_B(2,2));

    %% 定義定點數的最小精度是二進制的小數點後第幾位
    fractionLength = 16;

    %% Define up road kernel
    Kernel1_1 = single([
        [-0.00497626, -0.01768333, -0.05964094];
        [-0.02601938, -0.01975832, -0.02469257];
        [ 0.05847118,  0.00472676, -0.19815663];
        [ 0.00605816,  0.01492452, -0.06276379];
        [-0.11725461,  0.01607647, -0.07908361];
        [-0.04896994, -0.01366265, -0.14275728];
        [ 0.01745121, -0.10355259, -0.10867032];
        [-0.13948832,  0.04233619, -0.01236753];
        [-0.19540155,  0.02043956,  0.07055884]
    ]);
    
    Kernel1_2 = single([
        [-0.0372048  , 0.04541341, -0.06135173];
        [-0.09180294 ,-0.09209794, -0.07155426];
        [-0.1366549  , 0.06539778, -0.10848293];
        [-0.01205251 , 0.02288399,  0.09428369];
        [-0.02666683 ,-0.16883007, -0.02974886];
        [ 0.01241125 ,-0.03211685, -0.03273777];
        [ 0.05408334 , 0.0497009 , -0.13035537];
        [-0.13848913 ,-0.09213451,  0.01611195];
        [-0.02629155 , 0.07561185, -0.0415753 ]
    ]);
    
    Kernel1_3 = single([
        [-0.0743801 , -0.03404925 , 0.00504279];
        [ 0.04425432,  0.029045   ,-0.18478215];
        [-0.01224091, -0.02000317 ,-0.19771387];
        [ 0.05828457,  0.00967073 , 0.05832021];
        [ 0.03348868, -0.1494516  ,-0.00137811];
        [-0.12311156,  0.12791653 ,-0.06591111];
        [-0.11117572, -0.01393472 , 0.00873169];
        [-0.01332207,  0.03985387 , 0.01974503];
        [ 0.07545087, -0.034493   ,-0.2092783 ]
    ]);
    
    %% 將Kernel中的數值轉換成為定點數
    Kernel1_1 = convertToFixedPoint(Kernel1_1, fractionLength);
    Kernel1_2 = convertToFixedPoint(Kernel1_2, fractionLength);
    Kernel1_3 = convertToFixedPoint(Kernel1_3, fractionLength);

    % 將原始 kernels 重新排列成三個獨立的通道
    kernel_1_1_R = reshape(Kernel1_1(:, 1)', 3, 3)';
    kernel_1_1_G = reshape(Kernel1_1(:, 2)', 3, 3)';
    kernel_1_1_B = reshape(Kernel1_1(:, 3)', 3, 3)';
    
    kernel_1_2_R = reshape(Kernel1_2(:, 1)', 3, 3)';
    kernel_1_2_G = reshape(Kernel1_2(:, 2)', 3, 3)';
    kernel_1_2_B = reshape(Kernel1_2(:, 3)', 3, 3)';
    
    kernel_1_3_R = reshape(Kernel1_3(:, 1)', 3, 3)';
    kernel_1_3_G = reshape(Kernel1_3(:, 2)', 3, 3)';
    kernel_1_3_B = reshape(Kernel1_3(:, 3)', 3, 3)';
    
    
%     % 顯示結果
%     disp('Kernel 1 for Red Channel (kernel_1_1_R):');
%     disp(kernel_1_1_R);
%     disp('Kernel 1 for Green Channel (kernel_1_1_G):');
%     disp(kernel_1_1_G);
%     disp('Kernel 1 for Blue Channel (kernel_1_1_B):');
%     disp(kernel_1_1_B);
%     
%     disp('Kernel 2 for Red Channel (kernel_1_2_R):');
%     disp(kernel_1_2_R);
%     disp('Kernel 2 for Green Channel (kernel_1_2_G):');
%     disp(kernel_1_2_G);
%     disp('Kernel 2 for Blue Channel (kernel_1_2_B):');
%     disp(kernel_1_2_B);
%     
%     
%     
%     disp('Kernel 3 for Red Channel (kernel_1_3_R):');
%     disp(kernel_1_3_R);
%     disp('Kernel 3 for Green Channel (kernel_1_3_G):');
%     disp(kernel_1_3_G);
%     disp('Kernel 3 for Blue Channel (kernel_1_3_B):');
%     disp(kernel_1_3_B);
    
    %% Define up road biases
    % biases
    biases_up_R = single(-0.05879152);
    biases_up_G = single(0.01324429);
    biases_up_B = single(-0.0693721);

    % 將bias轉成定點數
    biases_up_R = floatToFixedPoint(biases_up_R, fractionLength);
    biases_up_G = floatToFixedPoint(biases_up_G, fractionLength);
    biases_up_B = floatToFixedPoint(biases_up_B, fractionLength);
    
%     % 顯示變數的數值
%     disp('biases_up_R:');
%     disp(biases_up_R);
%     
%     disp('biases_up_G:');
%     disp(biases_up_G);
%     
%     disp('biases_up_B:');
%     disp(biases_up_B);
    
    %% Define down road kernel
    Kernel2_1 = single([
        [-0.16652016 , 0.08133829, -0.08826914];
        [-0.01908079 , 0.07525653, -0.11390969];
        [ 0.09756457 ,-0.07250968,  0.02460506];
        [-0.11356872 , 0.01220144, -0.09879354];
        [-0.15557522 ,-0.15698783, -0.03219426];
        [-0.07110278 , 0.12130903, -0.0466899 ];
        [-0.1320841  ,-0.05613358, -0.00708736];
        [ 0.00511316 , 0.10791284, -0.16225886];
        [-0.05127085 ,-0.15460436,  0.01624191]
    ]);
    
    Kernel2_2 = single([
        [-0.0605225 , -0.1227156 ,  0.06627062];
        [-0.10940037, -0.07349256, -0.16192475];
        [ 0.03524255,  0.02685969,  0.04221135];
        [ 0.03466512, -0.05974562,  0.06519875];
        [-0.0695577 , -0.06364866, -0.06901629];
        [ 0.04871377,  0.01267209,  0.02213699];
        [-0.15022248, -0.13280259, -0.08732694];
        [ 0.04723189, -0.04459285, -0.1582412 ];
        [ 0.01505814,  0.09522869,  0.02802872]
    ]);
    
    Kernel2_3 = single([
        [-0.0107283  ,-0.04979232, -0.02240079];
        [-0.1032339  ,-0.14123626,  0.05020542];
        [ 0.09738507 ,-0.14257829, -0.21269993];
        [-0.10668001 ,-0.14690599, -0.06116881];
        [ 0.08949675 ,-0.1635896 ,  0.07613028];
        [-0.05762513 ,-0.06017259, -0.2229525 ];
        [-0.12780154 ,-0.04446943, -0.06618945];
        [-0.09503673 ,-0.08607375, -0.05240195];
        [-0.03873015 ,-0.0656883 , -0.13760073]
    ]);

    %% 將kernel中的數值轉換成定點數
    Kernel2_1 = convertToFixedPoint(Kernel2_1, fractionLength);
    Kernel2_2 = convertToFixedPoint(Kernel2_2, fractionLength);
    Kernel2_3 = convertToFixedPoint(Kernel2_3, fractionLength);

    % 將原始 kernels 重新排列成三個獨立的通道
    kernel_2_1_R = reshape(Kernel2_1(:, 1)', 3, 3)';
    kernel_2_1_G = reshape(Kernel2_1(:, 2)', 3, 3)';
    kernel_2_1_B = reshape(Kernel2_1(:, 3)', 3, 3)';
    
    kernel_2_2_R = reshape(Kernel2_2(:, 1)', 3, 3)';
    kernel_2_2_G = reshape(Kernel2_2(:, 2)', 3, 3)';
    kernel_2_2_B = reshape(Kernel2_2(:, 3)', 3, 3)';
    
    kernel_2_3_R = reshape(Kernel2_3(:, 1)', 3, 3)';
    kernel_2_3_G = reshape(Kernel2_3(:, 2)', 3, 3)';
    kernel_2_3_B = reshape(Kernel2_3(:, 3)', 3, 3)';
    
    
%     % 顯示結果
%     disp('Kernel 2-1 for Red Channel (kernel_2_1_R):');
%     disp(kernel_2_1_R);
%     disp('Kernel 2-1 for Green Channel (kernel_2_1_G):');
%     disp(kernel_2_1_G);
%     disp('Kernel 2-1 for Blue Channel (kernel_2_1_B):');
%     disp(kernel_2_1_B);
%     
%     disp('Kernel 2-2 for Red Channel (kernel_2_2_R):');
%     disp(kernel_2_2_R);
%     disp('Kernel 2-2 for Green Channel (kernel_2_2_G):');
%     disp(kernel_2_2_G);
%     disp('Kernel 2-2 for Blue Channel (kernel_2_2_B):');
%     disp(kernel_2_2_B);
%     
%     disp('Kernel 2-3 for Red Channel (kernel_2_3_R):');
%     disp(kernel_2_3_R);
%     disp('Kernel 2-3 for Green Channel (kernel_2_3_G):');
%     disp(kernel_2_3_G);
%     disp('Kernel 2-3 for Blue Channel (kernel_2_3_B):');
%     disp(kernel_2_3_B);
    
    %% Define down road biases
    % biases
    biases_down_R = single( -0.04015872);
    biases_down_G = single(-0.02392048);
    biases_down_B = single(-0.05116179);

    % 將bias轉換成為定點數
    biases_down_R = floatToFixedPoint(biases_down_R, fractionLength);
    biases_down_G = floatToFixedPoint(biases_down_G, fractionLength);
    biases_down_B = floatToFixedPoint(biases_down_B, fractionLength);

%     % 顯示bias數值
%     disp('biases_up_R:');
%     disp(biases_up_R);
%     
%     disp('biases_up_G:');
%     disp(biases_up_G);
%     
%     disp('biases_up_B:');
%     disp(biases_up_B);
     
    %% operation here
    %% 合併Kernel
    Big_Kernel_uproad_R = kernel_1_1_R + kernel_1_2_R + kernel_1_3_R;
    Big_Kernel_uproad_G = kernel_1_1_G + kernel_1_2_G + kernel_1_3_G;
    Big_Kernel_uproad_B = kernel_1_1_B + kernel_1_2_B + kernel_1_3_B;

    Big_Kernel_downroad_R = kernel_2_1_R + kernel_2_2_R + kernel_2_3_R;
    Big_Kernel_downroad_G = kernel_2_1_G + kernel_2_2_G + kernel_2_3_G;
    Big_Kernel_downroad_B = kernel_2_1_B + kernel_2_2_B + kernel_2_3_B;
    
%     % 显示结果
%     disp('Big Kernel Uproad for Red Channel:');
%     disp(Big_Kernel_uproad_R);
%     
%     disp('Big Kernel Uproad for Green Channel:');
%     disp(Big_Kernel_uproad_G);
%     
%     disp('Big Kernel Uproad for Blue Channel:');
%     disp(Big_Kernel_uproad_B);
%     
%     disp('Big Kernel Downroad for Red Channel:');
%     disp(Big_Kernel_downroad_R);
%     
%     disp('Big Kernel Down for Green Channel:');
%     disp(Big_Kernel_downroad_G);
%     
%     disp('Big Kernel Down for Blue Channel:');
%     disp(Big_Kernel_downroad_B);

    %% UP road operation here
    % UP road conv
    output_up_conv_R = custom_conv2(input_cell_R,Big_Kernel_uproad_R);
    output_up_conv_G = custom_conv2(input_cell_G,Big_Kernel_uproad_G);
    output_up_conv_B = custom_conv2(input_cell_B,Big_Kernel_uproad_B);
    
%     % Result of uproad conv Display here
%     disp('output_up_conv_R');
%     disp(output_up_conv_R);
%     disp('output_up_conv_G');
%     disp(output_up_conv_G);
%     disp('output_up_conv_B');
%     disp(output_up_conv_B);

    % Up road bias
    output_up_bias_R = output_up_conv_R + biases_up_R;
    output_up_bias_G = output_up_conv_G + biases_up_G;
    output_up_bias_B = output_up_conv_B + biases_up_B;

%     % Result of bias display here
%     disp('output_up_bias_R');
%     disp(output_up_bias_R);
%     disp('output_up_bias_G');
%     disp(output_up_bias_G);
%     disp('output_up_bias_B');
%     disp(output_up_bias_B);

    % Up road relu
    output_up_relu_R = relu(output_up_bias_R);
    output_up_relu_G = relu(output_up_bias_G);
    output_up_relu_B = relu(output_up_bias_B);

%     % Display up road output relu R,G,B here
%     disp('output_up_relu_R');
%     disp(output_up_relu_R);
%     disp('output_up_relu_G');
%     disp(output_up_relu_G);
%     disp('output_up_relu_B');
%     disp(output_up_relu_B);
    
    % output uproad here;
    output_uproad_R = output_up_relu_R + medium_pxl_origin_R;
    output_uproad_G = output_up_relu_G + medium_pxl_origin_G;
    output_uproad_B = output_up_relu_B + medium_pxl_origin_B;
    
%     % display uproad here;
%     disp('Output Uproad R:');
%     disp(output_uproad_R);
%     
%     disp('Output Uproad G:');
%     disp(output_uproad_G);
%     
%     disp('Output Uproad B:');
%     disp(output_uproad_B);

    %% Down road operation here
    % Down road conv
    output_down_conv_R = custom_conv2(input_cell_R,Big_Kernel_downroad_R);
    output_down_conv_G = custom_conv2(input_cell_G,Big_Kernel_downroad_G);
    output_down_conv_B = custom_conv2(input_cell_B,Big_Kernel_downroad_B);

%     % Result of downroad conv Display here
%     disp('output_down_conv_R');
%     disp(output_down_conv_R);
%     disp('output_down_conv_G');
%     disp(output_down_conv_G);
%     disp('output_down_conv_B');
%     disp(output_down_conv_B);

    % Down road bias
    output_down_bias_R = output_down_conv_R + biases_down_R;
    output_down_bias_G = output_down_conv_G + biases_down_G;
    output_down_bias_B = output_down_conv_B + biases_down_B;

%     % Result of bias display here
%     disp('output_down_bias_R');
%      disp(output_down_bias_R);
%     disp('output_down_bias_G');
%      disp(output_down_bias_G);
%     disp('output_down_bias_B');
%      disp(output_down_bias_B);

    % Down road relu
    output_down_relu_R = relu(output_down_bias_R);
    output_down_relu_G = relu(output_down_bias_G);
    output_down_relu_B = relu(output_down_bias_B);

%     % Display down road output relu R,G,B here
%     disp('output_down_relu_R');
%      disp(output_down_relu_R);
%     disp('output_down_relu_G');
%      disp(output_down_relu_G);
%     disp('output_down_relu_B');
%      disp(output_down_relu_B);

    % output down here;
    output_downroad_R = output_down_relu_R + medium_pxl_origin_R;
    output_downroad_G = output_down_relu_G + medium_pxl_origin_G;
    output_downroad_B = output_down_relu_B + medium_pxl_origin_B;

%     % display uproad here;
%     disp('Output downroad R:');
%      disp(output_downroad_R);
%     
%     disp('Output downroad G:');
%      disp(output_downroad_G);
%     
%     disp('Output downroad B:');
%      disp(output_downroad_B);

    %% Final output 1pxl here
    output_onepxl_R = output_uproad_R + output_downroad_R;
    output_onepxl_G = output_uproad_G + output_downroad_G;
    output_onepxl_B = output_uproad_B + output_downroad_B;

%     % 显示结果
%     disp('Output One Pixel R:');
%     disp(output_onepxl_R);
%     
%     disp('Output One Pixel G:');
%     disp(output_onepxl_G);
%     
%     disp('Output One Pixel B:');
%     disp(output_onepxl_B);

    % 將所有輸出定點
    output_onepxl_R = floatToFixedPoint(output_onepxl_R, fractionLength);
    output_onepxl_G = floatToFixedPoint(output_onepxl_G, fractionLength);
    output_onepxl_B = floatToFixedPoint(output_onepxl_B, fractionLength);
    
    % 确保所有输入都是 single 类型
    output_onepxl_R = single(output_onepxl_R);
    output_onepxl_G = single(output_onepxl_G);
    output_onepxl_B = single(output_onepxl_B);
    
    % 将 RGB 三个通道乘以 16 并限定最大值不超过 16
    output_onepxl_R_scaled = min(output_onepxl_R * 16, 16);
    output_onepxl_G_scaled = min(output_onepxl_G * 16, 16);
    output_onepxl_B_scaled = min(output_onepxl_B * 16, 16);
    
    % 将 RGB 三个通道合并
    output_onepxl_combined = cat(3, output_onepxl_R_scaled, output_onepxl_G_scaled, output_onepxl_B_scaled);
    %     % 顯示結果
    %     disp('output_onepxl_combined')
    %     disp(output_onepxl_combined)


end