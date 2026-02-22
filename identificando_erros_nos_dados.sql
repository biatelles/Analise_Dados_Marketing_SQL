-- Identificando valores nulos dentro das colunas

SELECT
    COUNT (*) - COUNT (id) AS id_nulos,
    COUNT (*) - COUNT (nome_campanha) AS nome_nulos,
    COUNT (*) - COUNT (data_inicio) AS data_inicio_nulos,
    COUNT (*) - COUNT (data_fim) AS data_fim_nulos,
    COUNT (*) - COUNT (orcamento) AS orcamento_nulos,
    COUNT (*) - COUNT (publico_alvo) AS publico_alvo_nulos,
    COUNT (*) - COUNT (canais_divulgacao) AS canais_divulgacao_nulos,
    COUNT (*) - COUNT (tipo_campanha) AS tipo_campanha_nulos,
    COUNT (*) - COUNT (taxa_conversao) AS taxa_conversao_nulos,
    COUNT (*) - COUNT (impressoes) AS impressoes_nulos
FROM
    marketing.campanha;

-- Identificando se em alguma coluna existe o caracter "?"

SELECT *
FROM marketing.campanha
WHERE
    nome_campanha LIKE '%?%' OR
    CAST (data_inicio AS VARCHAR) LIKE '%?%' OR
    CAST (data_fim AS VARCHAR) LIKE '%?%' OR
    CAST (orcamento AS VARCHAR) LIKE '%?%' OR
    publico_alvo LIKE '%?%' OR
    canais_divulgacao LIKE '%?%' OR
    tipo_campanha LIKE '%?%' OR
    CAST (taxa_conversao AS VARCHAR) LIKE '%?%' OR
    CAST (impressoes AS VARCHAR) LIKE '%?%';

-- Identificando colunas com entradas duplicadas

SELECT
    nome_campanha,
    data_inicio,
    data_fim,
    orcamento,
    publico_alvo,
    canais_divulgacao,
    tipo_campanha,
    taxa_conversao,
    impressoes,
    COUNT (*) AS duplicadas
FROM
    marketing.campanha
GROUP BY
    nome_campanha,
    data_inicio,
    data_fim,
    orcamento,
    publico_alvo,
    canais_divulgacao,
    tipo_campanha,
    taxa_conversao,
    impressoes
HAVING
    COUNT (*) > 1;


-- Identificando se há outliers nas colunas numéricas, considerando como outliers os valores media +/- 1.5 * desvio_padrão

WITH stats AS (
    SELECT
        AVG(orcamento) AS media_orcamento,
        STDDEV(orcamento) AS desvio_orcamento,
        AVG(taxa_conversao) AS media_taxa,
        STDDEV(taxa_conversao) AS desvio_taxa,
        AVG(impressoes) AS media_impressoes,
        STDDEV(impressoes) AS desvio_impressoes
    FROM
        marketing.campanha  
)
SELECT
    id,
    nome_campanha,
    data_inicio,
    data_fim,
    orcamento,
    publico_alvo,
    canais_divulgacao,
    tipo_campanha,
    taxa_conversao,
    impressoes
FROM
    marketing.campanha, stats
WHERE
    orcamento < stats.media_orcamento - 1.5 * stats.desvio_orcamento OR
    orcamento > stats.media_orcamento + 1.5 * stats.desvio_orcamento OR
    taxa_conversao < stats.media_taxa - 1.5 * stats.desvio_taxa OR
    taxa_conversao > stats.media_taxa + 1.5 * stats.desvio_taxa OR
    impressoes < stats.media_impressoes - 1.5 * stats.desvio_impressoes OR
    impressoes > stats.media_impressoes + 1.5 * stats.desvio_impressoes;