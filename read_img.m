function img = read_img(filename, width, height)
    imagenComprimida = read_circulo(filename);
    img = descomprimirGray(imagenComprimida, width, height);
end

