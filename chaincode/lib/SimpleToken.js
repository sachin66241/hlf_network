'use strict';

const shim = require('fabric-shim');
const { Contract } = require('fabric-contract-api');

const clientIdentity = shim.ClientIdentity;

class SimpleToken extends Contract {
    async initLedger(ctx) {
        const identity = new clientIdentity(ctx.stub);
    }

    async assignAdmin(ctx) {
        const identity = new clientIdentity(ctx.stub);
        const ownerMSPId = identity.getMSPID();
        const enrollmentID = identity.getAttributeValue('hf.EnrollmentID');

        const owner = ownerMSPId + '.' + enrollmentID;
        const symbol = "EOS";
        const name = "EOS Token";
        const supply = "1000";

        const bufferSymbol = Buffer.from(symbol);
        const bufferName = Buffer.from(name);
        const initialSupply = Buffer.from(supply);
        try {
            await ctx.stub.putState("Symbol", bufferSymbol);
            await ctx.stub.putState("Name", bufferName);
            await ctx.stub.putState(owner, initialSupply);

            let tx_id = await ctx.stub.getTxID();
            return tx_id;
        } catch(error) {
            console.log(error);
            throw new Error(`Low on amount`);
        }
    }

    async allot(ctx, reciever, amount){
        const identity = new clientIdentity(ctx.stub);
        const adminMSPId = identity.getMSPID();
        const enrollmentID = identity.getAttributeValue('hf.EnrollmentID');
        const role = identity.getAttributeValue('hf.Type');

        const admin = adminMSPId + '.' + enrollmentID;

        if(role != 'admin')
            throw new Error(`Permission denied`);
    
        var amt = parseFloat(amount);
        var senderMSPId = admin;
        var senderBalance = await ctx.stub.getState(senderMSPId);
        var recieverBalance = await ctx.stub.getState(reciever);
        if (senderBalance.toString() == "") {
            senderBalance = Buffer.from("0");
        }
        if (recieverBalance.toString() == "") {
            recieverBalance = Buffer.from("0");
        }
        var floatSenderBalance = parseFloat(senderBalance.toString());
        var floatRecieverBalance = parseFloat(recieverBalance.toString());
        if (floatSenderBalance < amt) {
            throw new Error(`Low on amount`);
        }
        try {
            var  newSenderBalance = floatSenderBalance - amt;
            var newRecieverBalance = floatRecieverBalance + amt;
            await ctx.stub.putState(senderMSPId, Buffer.from(newSenderBalance.toString()));
            await ctx.stub.putState(reciever, Buffer.from(newRecieverBalance.toString()));

            let tx_id = await ctx.stub.getTxID();
            return tx_id;
        } catch(error) {
            throw new Error(error);
        }
    }

    async getBalance(ctx, ownerId) {
        var balance = await ctx.stub.getState(ownerId);
        const symbol = await ctx.stub.getState('Symbol');

        if (balance.toString() === ""){
            balance = Buffer.from("0");
        }
        var balanceStr = balance.toString();
        return balanceStr;
    }

    async getHistory(ctx, ownerId) {
        var result = await ctx.stub.getHistoryForKey(ownerId);
        return result.toString();
    }

    async transfer(ctx, reciever, amount) {
        const senderIdentity = new clientIdentity(ctx.stub);
        const senderMSPId = senderIdentity.getMSPID();
        const enrollmentID = senderIdentity.getAttributeValue('hf.EnrollmentID');
        const sender = senderMSPId + '.' + enrollmentID;

        var amt = parseFloat(amount);
        var senderBalance = await ctx.stub.getState(sender);
        var recieverBalance = await ctx.stub.getState(reciever);
        if (senderBalance.toString() == "") {
            senderBalance = Buffer.from("0");
        }
        if (recieverBalance.toString() == "") {
            recieverBalance = Buffer.from("0");
        }
        var floatSenderBalance = parseFloat(senderBalance.toString());
        var floatRecieverBalance = parseFloat(recieverBalance.toString());
        if (floatSenderBalance < amt) {
                throw new Error(`Low on amount`);
        }

        try {
            var  newSenderBalance = floatSenderBalance - amt;
            var newRecieverBalance = floatRecieverBalance + amt;
            await ctx.stub.putState(sender, Buffer.from(newSenderBalance.toString()));
            await ctx.stub.putState(reciever, Buffer.from(newRecieverBalance.toString()));

            let tx_id = await ctx.stub.getTxID();
            return tx_id;
        } catch(error) {
            throw new Error(error);
        }
    }
}

module.exports = SimpleToken;