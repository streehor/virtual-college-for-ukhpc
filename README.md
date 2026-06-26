# Virtual College for UKHPC

A virtual tour of the Ust-Kamenogorsk Higher Polytechnic College (UKHPC) developed as a diploma project using the Godot Engine.

<p align="center">
  <img src="https://github.com/user-attachments/assets/832ce45a-aa39-4c9c-bd12-4dc9d1be78cf" alt="Virtual College Logo" width="200">
</p>

## About the Project

"Virtual College" is an interactive 3D tour of the Ust-Kamenogorsk Higher Polytechnic College. The project was developed as a diploma project for integration into the official website of the educational institution. It provides applicants and students with the opportunity to remotely explore the college's infrastructure.

**Live Links:**
- Website Integration: [ukptk.edu.kz](https://www.ukptk.edu.kz/) ("Virtual college" button on the desktop version).
- Direct Access: [tour.ukhpc.kz](https://tour.ukhpc.kz/).

## Key Features

- **Interactive 3D Environment:** Navigation through detailed scenes of the college premises.
- **User Interface (UI):** Menu system for quick navigation between locations.
- **Localization:** Multi-language support (Kazakh, Russian) via a built-in translation system.
- **Web Optimization:** Configured for HTML5 export to run directly in a web browser.

## Technologies

- **Engine:** Godot Engine
- **Scripting:** GDScript
- **Data Structure:** CSV for localization, imported 3D models (GLTF/OBJ) and textures (WebP/PNG).

## Demonstration

<details>
  <summary>Main Menu</summary>
  <img width="791" height="441" alt="main_screen" src="https://github.com/user-attachments/assets/84289385-40f8-472d-b777-b01e87375d39" />
</details>
<details>
  <summary>UI</summary>
  <img width="791" height="441" alt="ui" src="https://github.com/user-attachments/assets/027947d4-5169-49b1-96aa-fb14e7269b76" />
</details>
<details>
  <summary>Example Room</summary>
  <img width="791" height="441" alt="random_frame" src="https://github.com/user-attachments/assets/8434adad-cca4-4a19-aed4-295354798ddd" />
</details>

## Repository Structure

- `models/` — source 3D models of locations and objects.
- `materials/` and `textures/` — scene materials and textures.
- `scenes/` — assembled project scenes.
- `UI/` — user interface elements.
- `translations.csv` — translation database.

## Running from Source

Godot Engine is required for local launch and editing.

1. Clone the repository:
   ```bash
   git clone [https://github.com/streehor/virtual-college-for-ukhpc.git](https://github.com/streehor/virtual-college-for-ukhpc.git)
