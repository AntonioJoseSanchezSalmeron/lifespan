function img = descomprimirGray(imagenComprimida, width, height)
    img = im2uint8(mat2gray(vec2mat(descomprimir_circulo(imagenComprimida, width, height), width)));
end