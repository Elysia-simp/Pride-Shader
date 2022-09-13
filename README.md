# Disclaimer

Please don't come for me to add me on discord for help with decrypting this game I can only encourage you to look up how to do it yourself or study it yourself

everything written here was originally written by QualiArts and as such they have every right to request a take down (All I did was simplify most of their functions)


You'll also need to use any Stencil shaders (like alphaeye) and have it support the hair's alphamap for stencils with eyebrows and eyes

*I AM ALSO NOT RESPONSIBLE FOR ANY ERRORS YOU MIGHT GET USING THIS SHADER WITH OTHER MODELS THAN WHAT'S INTENDED*


# Prerequisites
1) obviously a way to decrypt/rip the game
2) models exported with [minmode's PMX noesis script](https://www.deviantart.com/minmode/art/Update-1-6-Noesis-PMX-VMD-export-809252773)

    PS: I'm not adding support for models exported with blender and/or whatever other means, Sorry but I deem it unneeded to make the shader more complicated than I already made it lol
    
    
4) some brain power

# Rules

Albiet basic rules please follow them

1) Please credit me as either Chips, Chi, Chizukimo (don't care they're all me)

2) Please do not use anything here for commercial profit

3) You are allowed to modify this shader to your hearts content

4) You may distribute the edited Material.fx file for convenience but if you didn't edit the main shader (shader.fxh/sub folder) Please link to here instead

5) I am not responsible for the damage one may cause with this shader

6) Finally Please do not use this for R-18 related content

(like please they're all minors and one of them is dead)

# Usage

Set your Def texture in the Spheremap slot and your Sdw in the Toon slot

Now set your Materials (in PMXE) as such

SubTex for anything that isn't a Face mesh and you can do Add or Multi for anything that is a face (leaving it disabled will make mmd ignore it entirely)

use photoshop with nvidia tools to make any Cubemaps you might need (you can also use any external programs I haven't really tested much)

then just duplicate Material.fx and just give it the proper names

if you want self shadow load HgShadow (I'm not using mmd's default shadowmap)

that should be it really just report any bugs/errors I've made

Errors related to normals are being looked into (but cannot garentee a 100% fix)
# Credits

HariganeP for HgShadow_ObjHeader

# Other notes

This game uses tangents as previously stated however due to limitations that MMD has, So I can't possibly fix EVERY error that might of arrised from this at this time. Please understand!

(if you're interested)to rip them you'll need to study a bit and use unity to import the assets directly as AssetRipper (or any similar tool) will toss a unity version error or wont support tangents


However this is completely optional (As of right now)



Any and all error reports should be made in Issues or you can contact me in Discord: Chi#4089

Though do consider reading the usage again before making the report and accidentally sending an honest mistake rather than an actual error report

# Examples
![Sample1](https://user-images.githubusercontent.com/105132829/189573418-5c56788d-60e9-48dc-b118-15f8ff63a926.png)
![Sample2](https://user-images.githubusercontent.com/105132829/189573443-e88dc231-a9ed-4b88-aa7f-fb6bc8eebef5.png)
![Sample3](https://user-images.githubusercontent.com/105132829/189573459-9c505e28-c372-482c-be6b-58fba47447b0.png)

