import mongoose from 'mongoose';
import element from "./elements";
import request from "./requests";
import room from "./rooms";

const blocoSchema = new mongoose.Schema({
    nome: String,
    elementos: [element],
    requests: [request],
    salas: [room]
  });
  
  const Bloco = mongoose.model('Bloco', blocoSchema);
  
  module.exports = Bloco;