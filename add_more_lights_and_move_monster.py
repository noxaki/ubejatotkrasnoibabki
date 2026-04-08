import re

with open('levels/main_level.tscn', 'r') as f:
    content = f.read()

# 1. Add even more lights
# Find the Lights node block
lights_block_regex = r'(\[node name="Lights" type="Node3D".*?(?=\n\[node name="Items"))'

additional_lights = """
[node name="Light_G_Corner1" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -45, 4, -45)
light_energy = 0.5
omni_range = 15.0

[node name="Light_G_Corner2" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 45, 4, -45)
light_energy = 0.5
omni_range = 15.0

[node name="Light_G_Corner3" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -45, 4, 45)
light_energy = 0.5
omni_range = 15.0

[node name="Light_G_Corner4" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 45, 4, 45)
light_energy = 0.5
omni_range = 15.0

[node name="Light_U_Corner1" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -45, 14, -45)
light_energy = 0.5
omni_range = 15.0

[node name="Light_U_Corner2" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 45, 14, -45)
light_energy = 0.5
omni_range = 15.0

[node name="Light_U_Corner3" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -45, 14, 45)
light_energy = 0.5
omni_range = 15.0

[node name="Light_U_Corner4" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 45, 14, 45)
light_energy = 0.5
omni_range = 15.0

[node name="Light_Hall_Long1" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 4, -25)
light_energy = 0.5
omni_range = 20.0

[node name="Light_Hall_Long2" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 4, 25)
light_energy = 0.5
omni_range = 20.0

[node name="Light_Hall_Long3" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -25, 4, 0)
light_energy = 0.5
omni_range = 20.0

[node name="Light_Hall_Long4" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 25, 4, 0)
light_energy = 0.5
omni_range = 20.0

[node name="Light_Monster_Room" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -30, 4, 40)
light_color = Color(1, 0, 0, 1)
light_energy = 1.0
omni_range = 15.0
"""

match = re.search(lights_block_regex, content, re.DOTALL)
if match:
    old_lights = match.group(1)
    new_lights = old_lights + additional_lights
    content = content.replace(old_lights, new_lights)

# 2. Move monster to room next to player
# Player is at (0, 1.6, 45).
# Move monster to (-30, 1.6, 40) - inside a room area on ground floor.
content = re.sub(r'\[node name="Monster".*?\ntransform = Transform3D\(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 10.6, -45\)', 
                 '[node name="Monster" type="CharacterBody3D" parent="." unique_id=1072172656 instance=ExtResource("7_monster_scene")]\ntransform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -30, 1.6, 40)', 
                 content)

with open('levels/main_level.tscn', 'w') as f:
    f.write(content)

print("Done")
