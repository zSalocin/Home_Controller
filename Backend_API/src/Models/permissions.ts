import mongoose from 'mongoose';

const permissionsSchema = new mongoose.Schema({
    blockCreate: {type: Boolean, default: false},
  });

  const blockPermissionSchema = new mongoose.Schema({
    blockId: { type: mongoose.Schema.Types.ObjectId, ref: 'Block', required: true },
    create: { type: Boolean, default: false },
    delete: { type: Boolean, default: false },
    update: { type: Boolean, default: false },
});

const roomPermissionSchema = new mongoose.Schema({
    blockId: { type: mongoose.Schema.Types.ObjectId, ref: 'Room', required: true },
    create: { type: Boolean, default: false },
    delete: { type: Boolean, default: false },
    update: { type: Boolean, default: false },
});

const elmentPermissionSchema = new mongoose.Schema({
    blockId: { type: mongoose.Schema.Types.ObjectId, ref: 'Element', required: true },
    create: { type: Boolean, default: false },
    delete: { type: Boolean, default: false },
    update: { type: Boolean, default: false },
});

  export default permissionsSchema;