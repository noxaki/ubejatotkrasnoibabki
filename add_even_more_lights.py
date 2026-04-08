import re

with open('levels/main_level.tscn', 'r') as f:
    content = f.read()

# 1. Add EVEN MORE lights
lights_block_regex = r'(\[node name="Lights" type="Node3D".*?(?=\n\[node name="Items"))'

additional_lights = """
[node name="FloodLight_G1" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 15, 4, 15)
light_energy = 0.8
omni_range = 25.0

[node name="FloodLight_G2" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -15, 4, 15)
light_energy = 0.8
omni_range = 25.0

[node name="FloodLight_G3" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 15, 4, -15)
light_energy = 0.8
omni_range = 25.0

[node name="FloodLight_G4" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -15, 4, -15)
light_energy = 0.8
omni_range = 25.0

[node name="FloodLight_U1" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 15, 14, 15)
light_energy = 0.8
omni_range = 25.0

[node name="FloodLight_U2" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -15, 14, 15)
light_energy = 0.8
omni_range = 25.0

[node name="FloodLight_U3" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 15, 14, -15)
light_energy = 0.8
omni_range = 25.0

[node name="FloodLight_U4" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -15, 14, -15)
light_energy = 0.8
omni_range = 25.0

[node name="Ambient_G_Center" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 4, 0)
light_energy = 0.8
omni_range = 35.0

[node name="Ambient_U_Center" type="OmniLight3D" parent="Lights"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 14, 0)
light_energy = 0.8
omni_range = 35.0
"""

match = re.search(lights_block_regex, content, re.DOTALL)
if match:
    old_lights = match.group(1)
    new_lights = old_lights + additional_lights
    content = content.replace(old_lights, new_lights)

# 2. Move monster to EXACT room where player is located
# Player is at (0, 1.6, 45).
# Move monster to (0, 1.6, 35) - literally right behind/in front of player in the same room.
content = re.sub(r'\[node name="Monster" type="CharacterBody3D" parent="\." unique_id=1072172656 instance=ExtResource\("7_monster_scene"\)\]\ntransform = Transform3D\(1, 0, 0, 0, 1, 0, 0, 0, 1, -30, 1.6, 40\)', 
                 '[node name="Monster" type="CharacterBody3D" parent="." unique_id=1072172656 instance=ExtResource("7_monster_scene")]\ntransform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1.6, 35)', 
                 content)

with open('levels/main_level.tscn', 'w') as f:
    f.write(content)

print("Done")
