exports.handler = async (event) => {
    const payload = {
        data: new Date(),
        message: "awesome lambda function"
    };
    return JSON.stringify(payload);
};
