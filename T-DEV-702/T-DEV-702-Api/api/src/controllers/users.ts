import { FastifyRequest, FastifyReply, FastifyInstance } from 'fastify';
import { $Enums, Role , User } from '@prisma/client';
import { UpdateUserData } from '../routes/users';

// Typage des réponses utilisateur
export type UserResponse = {
  id: number;
  firstName: string | null;
  lastName: string | null;
  email: string;
  phoneNumber: string | null;
  roles: $Enums.Role[];
};

// Typage des données de création et de mise à jour
export type CreateUserData = {
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  password: string;
  role: Role[];
  address?: {
    country: string;
    city: string;
    postalCode: number;
    streetNumber: string;
    streetType: string;
  };
};

// Typage des données de suppression et de mise à jour
export type DeleteUserData = {
  id: number
};

// export type UpdateUserData = Partial<CreateUserData & {
//   address?: {
//     id: number;
//     country?: string;
//     city?: string;
//     postalCode?: number;
//     streetNumber?: string;
//     streetType?: string;
//   };
// }>;

// GET ALL USERS
export async function getAll(
  request: FastifyRequest,
  reply: FastifyReply,
  fastify: FastifyInstance
) {

  try {
    const users: UserResponse[] = await fastify.prisma.user.findMany({
      select: {
        id: true,
        firstName: true,
        lastName: true,
        email: true,
        phoneNumber: true,
        roles: true,
      },
    });

    if (users.length === 0) {
      reply.code(404).send({ message: "Aucun utilisateur n'est présent" });
    }

    reply.send(users);
  } catch (error) {
    
    console.error('Error while fetching users:', error); // Log de l’erreur
    reply.code(500).send({ message: 'An error occurred while fetching users.' });
  }
}

// GET USER BY ID
export async function getUserById(
  request: FastifyRequest<{ Params: { userId: number } }>,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let data = request.params;
  const userId = data.userId;
  
  if (isNaN(userId)) {
    return reply.code(400).send({ message: "Invalid user ID" });
  }

  try {
    const user: UserResponse | null = await fastify.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        firstName: true,
        lastName: true,
        email: true,
        phoneNumber: true,
        roles: true,
      },
    });

    if (!user) {
      return reply.code(404).send({ message: 'User not found.' });
    }

    reply.send(user);
  } catch (error) {
    console.error(error);
    reply.code(500).send({ message: 'An error occurred while fetching the user.' });
  }
}


// CREATE USER
export async function createUser(
  request: FastifyRequest<{ Body: CreateUserData }>,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let data = request.body;

  const { firstName, lastName, email, phone, password, role, address } = data;

  try {
    const newUser = await fastify.prisma.user.create({
      data: {
        firstName: data.firstName,
        lastName: data.lastName,
        email: data.email,
        phoneNumber: data.phone,
        password: data.password,
        roles: data.role,
        
      },
    });

    if (data.address) {
      await fastify.prisma.address.create({
        data: {
          ...data.address,
          Userid: newUser.id, 
          street: `${data.address.streetNumber} ${data.address.streetType}`,
        },
      });
    }

    return reply.code(201).send(newUser);
  } catch (error) {
    console.error(error);
    return reply.code(500).send({ message: 'An error occurred while creating the user.' });
  }
}

// UPDATE USER
export async function updateUser(
  request: FastifyRequest<{ Params: { userId: number }, Body: UpdateUserData }>,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let data = request.params;
  const userId = data.userId;
  if (isNaN(userId)) {
    return reply.code(400).send({ message: "Invalid user ID" });
  }

  let updates = request.body;

  try {
    // Vérifier si l'utilisateur existe avant la mise à jour
    const user = await fastify.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      return reply.code(404).send({ message: "User not found." });
    }

    // Mise à jour des rôles en validant chaque rôle
    let roleUpdate;
    if (updates.role) {
      if (!Array.isArray(updates.role)) {
        return reply.code(400).send({ message: "Roles must be an array." });
      }

      const validRoles = updates.role.map((r) => {
        if (!Object.values(Role).includes(r as Role)) {
          throw new Error(`Invalid role: ${r}`);
        }
        return r as Role;
      });

      roleUpdate = { set: validRoles };
    }

    // Mise à jour de l'utilisateur
    const updatedUser = await fastify.prisma.user.update({
      where: { id: userId },
      data: {
        firstName: updates.firstName ?? undefined,
        lastName: updates.lastName ?? undefined,
        email: updates.email ?? undefined,
        phoneNumber: updates.phone ?? undefined,
        password: updates.password ?? undefined, // Pas de hashage ici
        roles: roleUpdate ?? undefined,
      },
    });

    // Mise à jour de l'adresse si fournie
    if (updates.address && updates.address.id) {
      await fastify.prisma.address.update({
        where: { id: updates.address.id },
        data: {
          country: updates.address.country ?? undefined,
          city: updates.address.city ?? undefined,
          postalCode: updates.address.postalCode ?? undefined,
          street: `${updates.address.streetNumber} ${updates.address.streetType}`,
        },
      });
    }

    return reply.send({ message: "User updated successfully", user: updatedUser });
  } catch (error) {
    console.error("Error updating user:", error);
    return reply.code(500).send({ message: "An error occurred while updating the user." });
  }
}



// DELETE USER
export async function deleteUser(
  request: FastifyRequest<{ Params: { userId: number } }>,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let data = request.params;
  const userId = data.userId;

  try {
    const user = await fastify.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      return reply.code(404).send({ message: 'User not found.' });
    }

    await fastify.prisma.address.deleteMany({
      where: { Userid: user.id }, // Utiliser userId pour supprimer les adresses associées
    });

    await fastify.prisma.user.delete({
      where: { id: userId },
    });

    reply.send({ message: `User with id ${userId} deleted successfully.` });
  } catch (error) {
    console.error(error);
    reply.code(500).send({ message: 'An error occurred while deleting the user.' });
  }
}

// USER MY
// Get my user


export async function getMyUser(
  request: FastifyRequest,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let userId = request.jwt?.id; 

  if (!userId) {
    return reply.status(401).send({ message: 'Unauthorized' });
  }
  userId = Number(userId);
  
  try {
    const user = await fastify.prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        firstName: true,
        lastName: true,
        email: true,
        phoneNumber: true,
        roles: true,
      },
    });

    if (!user) {
      return reply.code(404).send({ message: 'User not found' });
    }

    reply.send(user);
  } catch (error) {
    console.error(error);
    reply.status(500).send({ message: 'An error occurred while retrieving user.' });
  }
}

// UpdateMyUser
// Modifier l'utilisateur connecté (users/my)
export async function modifyMyUser(
  request: FastifyRequest,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let userId = request.jwt?.id;
  let updates = request.body as Partial<{
    firstName: string;
    lastName: string;
    email: string;
    phone: string;
    password: string;
    role: Role[];
  }>;

  if (!userId) {
    return reply.status(401).send({ message: "Unauthorized" });
  }

  userId = Number(userId);

  if (isNaN(userId)) {
    return reply.status(400).send({ message: "Invalid user ID" });
  }

  try {
    const user = await fastify.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      return reply.code(404).send({ message: "User not found." });
    }

    // Empêcher les users à changer de rôle
    if (updates.role) {
      return reply.code(403).send({ message: "You cannot change your role." });
    }

    const updatedUser = await fastify.prisma.user.update({
      where: { id: userId },
      data: {
        firstName: updates.firstName ?? undefined,
        lastName: updates.lastName ?? undefined,
        email: updates.email ?? undefined,
        phoneNumber: updates.phone ?? undefined,
        password: updates.password ?? undefined, // Pas de hashage ici
      },
    });

    return reply.send({
      message: "User updated successfully",
      user: updatedUser,
    });
  } catch (error) {
    console.error("Error updating user:", error);
    return reply.code(500).send({ message: "An error occurred while updating the user." });
  }
}


// DELETE MY USER
export async function deleteMyUser(
  request: FastifyRequest,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let userId = request.jwt?.id;

  if (!userId) {
    return reply.status(401).send({ message: 'Unauthorized' });
  }

  userId = Number(userId); 

  if (isNaN(userId)) {
    return reply.status(400).send({ message: 'Invalid user ID' });
  }

  try {
    const user = await fastify.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      return reply.code(404).send({ message: 'User not found.' });
    }

    await fastify.prisma.jwt.deleteMany({
      where: { idUser: userId },
    });

    await fastify.prisma.address.deleteMany({
      where: { Userid: userId },
    });


    await fastify.prisma.user.delete({
      where: { id: userId },
    });

    return reply.send({ message: `User with id ${userId} deleted successfully.` });
  } catch (error) {
    if (error instanceof Error) {
      console.error('Error details:', error.message);
      return reply.status(500).send({ 
        message: 'An error occurred while deleting the user.',
        error: error.message 
      });
    } else {
      console.error('Unknown error:', error);
      return reply.status(500).send({ 
        message: 'An unknown error occurred.', 
        error: JSON.stringify(error) 
      });
    }
  }
}
