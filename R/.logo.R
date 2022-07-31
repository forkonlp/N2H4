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

library(showtext)

font_add_google('Inconsolata', 'inconsolata')
showtext_auto()

library(hexSticker)

# for windows
sticker(
  "./man/figures/logo_crop.png",
  s_x = 1.04, s_y = 0.6,
  package = "N2H4",
  p_family = "inconsolata",
  p_fontface = "bold",
  p_size = 100, p_y = 1.15, p_x = 1.02,
  filename = "man/figures/logo.png",
  h_fill = "#3f63bf",
  p_color = "#ffffff",
  h_color = "#3f63bf",
  url = "forkonlp.github.io/N2H4",
  u_size = 10,
  u_color = "#00bd39",
  dpi = 500
)
