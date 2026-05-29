# Estágio de build
FROM node:alpine AS builder

WORKDIR /app

# Copia apenas os arquivos de dependência
COPY package*.json ./

# Instala todas as dependências (incluindo devDependencies)
RUN npm ci --only=production=false

# Copia o código fonte
COPY . .

# Se você tiver um build step (TypeScript, React, etc), execute aqui
# RUN npm run build

# Estágio de produção
FROM node:alpine

WORKDIR /app

# Cria usuário não-root para segurança
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Copia apenas as dependências de produção do estágio builder
COPY --from=builder --chown=nodejs:nodejs /app/node_modules /app/node_modules
COPY --chown=nodejs:nodejs package*.json ./
COPY --chown=nodejs:nodejs . .

# Se você tiver uma pasta de build, copie apenas os arquivos necessários
# COPY --from=builder --chown=nodejs:nodejs /app/dist /app/dist

# Remove arquivos desnecessários para produção
RUN rm -rf tests *.md .git .gitignore && \
    npm cache clean --force

# Muda para usuário não-root
USER nodejs

EXPOSE 3000

# Usa array syntax para melhor signal handling
CMD ["npm", "start"]
