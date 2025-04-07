import { FastifyInstance, FastifyPluginAsync } from 'fastify';
import Ajv from 'ajv';
import addFormats from 'ajv-formats';
import { isValidPhoneNumber } from 'libphonenumber-js'

export const phoneSchema = {
    $id: 'phone',
    type: 'string',
    format: 'phone',
    example: '+1234567890'
} as const;

const validatorPhone: FastifyPluginAsync = async (fastify: FastifyInstance) => {
    // Initialize Ajv with custom formats
    const ajv = new Ajv({ 
        removeAdditional: true,
        useDefaults: true,
        coerceTypes: true,
        allErrors: true,
        strict: false
     });
    addFormats(ajv);

    // Custom phone format validation
    ajv.addFormat('phone', (data: string) => {
        return isValidPhoneNumber(data);
    });

    // Use the custom Ajv instance in Fastify
    fastify.setValidatorCompiler(({ schema }) => {
        return ajv.compile(schema);
    });

    const phoneSchema = {
        $id: 'phone',
        type: 'string',
        format: 'phone'
    } as const;

    // Add the schema to Ajv, not Fastify
    ajv.addSchema(phoneSchema); //! test without this line
    fastify.addSchema({...phoneSchema, example: '+1234567890'});
}

export default validatorPhone;