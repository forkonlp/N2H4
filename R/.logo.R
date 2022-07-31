download.file(
  "https://ssl.pstatic.net/static.news/image/news/ogtag/navernews_stand_20160802.png",
  "./man/figures/nnews.png",
  mode = "wb"
)

library(magick)

im <- image_read("./man/figures/nnews.png")
imc <- image_crop(im, "98x40+15+80")
imc
image_write(imc,
            path = "./man/figures/logo_crop.png",
            format = "png",
            )

library(hexSticker)

# for windows
sticker(
  "./man/figures/logo_crop.png",
  s_x = 1, s_y = 0.7,
  package = "N2H4",
  p_size = 70, p_y = 1.2, p_x = 1,
  filename = "man/figures/logo.png",
  h_fill = "#3f63bf",
  p_color = "#ffffff",
  h_color = "#3f63bf",
  url = "forkonlp.github.io/N2H4",
  u_size = 9,
  u_color = "#00bd39",
  dpi = 500
)
