#!/bin/sh

# accent="#8bb158"
# accent="#6fe2e2"
# accent="#C5FFFF"
accent="#ee0000"

file_base="neon.png"
file_text="foo.png"
file_back="bar.png"
file_input="test.png"
file_output="logo.png"

x=192
y=192

imagemagick-string \
    -i '{}' \
    -o ${file_text} \
    -bg None \
    -fg "${accent}" \
    -fn 'FiraCode-Nerd-Font-Reg' \
    -l ${x} \
    -w ${y} \
    -e "-stroke ${accent} -strokewidth 5"

# cp {foo,bar}.png -v

trim() {
    $(which magick || which convert) \
        ${1} \
        -trim +repage \
        ${2}
}

# imagemagick-shadow -i ${file_text} -o ${file_back} -sc none
trim ${file_text} ${file_back}
# imagemagick-shadow -i ${file_back} -o ${file_back} -sc none -sw 500

    #-ps 200
# imagemagick-trim ${file_text}
# imagemagick-shadow -i ${file_text} -o ${file_text} -sc Black

# convert ${file_back} ${file_output}  # -sw 0 -sc black -bc none -bw 0.02 -sr 0
imagemagick-shadow -i ${file_back} -o ${file_output}  # -sw 0 -sc black -bc none -bw 0.02 -sr 0
# imagemagick-shadow -i ${file_output} -o ${file_output}  # -sw 0 -sc black -bc none -bw 0.02 -sr 0

# \cp -f ${file_base} ${file_input}

# file_input="${file_text}"
# $(which magick || which convert) \
#     ${file_input} \
#     -resize ${x}x${y}^ \
#     -fill black -colorize 60% \
#     -gravity center \
#     -extent ${x}x${y}^ \
#     ${file_output}
#     # ${file_input}

# imagemagick-round -i ${file_input} -o ${file_input}
# imagemagick-merge -i "${file_back} ${file_input}" -o ${file_output} -f 100

# for name in ${file_text} ${file_back} ${file_input}; do
#   if [ -f "${name}" ]; then
#     rm $name
#   fi
# done

# imagemagick-shadow -i ${file_text} -o ${file_text} -sw 0 -sc none -bc black -bw 0.02 -sr 0
