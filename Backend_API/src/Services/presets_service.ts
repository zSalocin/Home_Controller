// services/elementService.ts
import fs from 'fs';
import path from 'path';

export function getValidElements(): string[] {
    const filePath = path.join(__dirname, '../Presets/Elementtypes_preset.json');
    const data = fs.readFileSync(filePath, 'utf-8');
    const jsonData = JSON.parse(data);
    return jsonData.validElementTypes;
}
