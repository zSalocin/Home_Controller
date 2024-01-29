import { Room } from '../Models/room_model';
import Block from '../Models/blocks_model';

// Falta TESTAR

export async function addRoom(userId: string, blockId: string, newRoomData: any) {
  try {
    const block = await Block.findOne({ _id: blockId, userId });

    if (!block) {
      throw new Error('Block not found for the user.');
    }

    const newRoom = new Room(newRoomData); // Pass the data directly
    block.room.push(newRoom); // Assuming 'room' is the correct array field in the block schema
    await block.save();

    return newRoom;
  } catch (error) {
    console.error('Error adding a new room:', error);
    throw new Error('Error adding a new room');
  }
}
  
  export async function getRoom(userId: string, blockId: string, roomId: string) {
    try {
      const block = await Block.findOne({ _id: blockId, userId });
  
      if (!block) {
        throw new Error('Block not found for the user.');
      }
  
      const room = block.room.id(roomId);
  
      if (!room) {
        throw new Error('Room not found in the block.');
      }
  
      return room;
    } catch (error) {
      console.error('Error getting room:', error);
      throw new Error('Error getting room');
    }
  }
  
export async function getAllRooms(userId: string, blockId: string) {
  try {

    const block = await Block.findOne({ _id: blockId, userId });

    if (!block) {
      throw new Error('Block not found for the user.');
    }

    return block.room;
  } catch (error) {
    console.error('Error getting all rooms:', error);
    throw new Error('Error getting all rooms');
  }
}